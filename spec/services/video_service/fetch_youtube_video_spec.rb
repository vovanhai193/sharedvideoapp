require "rails_helper"

describe ::VideoService::FetchYoutubeVideo do
  let(:youtube_id) { "8bi0yaEe0xU" }
  let(:success_data) do
    {
      "kind" => "youtube#videoListResponse",
      "etag" => "rUW2HK0K78C-t8Buc0PHG3Hkq7k",
      "items" =>
        [
          {
            "kind" => "youtube#video",
            "etag" => "lLneUyCm-yIWxytzZktEGJ_EouQ",
            "id" => "8bi0yaEe0xU",
            "snippet" =>
              {
                "publishedAt" => "2023-02-18T05:51:43Z",
                "channelId" => "UCvckir3Kq2WThY3k_34ZGNw",
                "title" => "This is title",
                "description" => "This is description",
              }
          }
        ],
      "pageInfo" => { "totalResults" => 1, "resultsPerPage" => 1 }
    }
  end
  let(:empty_data) do
    {
      "kind" => "youtube#videoListResponse",
      "etag" => "YIUPVpqNjppyCWOZfL-19bLb7uk",
      "items" => [],
      "pageInfo" => { "totalResults" => 0, "resultsPerPage" => 0 }
    }
  end

  subject {
    described_class.new(youtube_id)
  }

  context 'fetch youtube video successfully' do
    before do
      response = Net::HTTPSuccess.new(1.0, '200', 'OK')
      expect_any_instance_of(Net::HTTP).to receive(:request) { response }
      expect(response).to receive(:body) { success_data.to_json }  
    end

    it 'returns title and description' do
      data = subject.perform

      expect(data[:title]).to eq(success_data['items'].first&.dig('snippet', 'title'))
      expect(data[:description]).to eq(success_data['items'].first&.dig('snippet', 'description'))
    end
  end

  context 'fetch youtube video not found' do
    before do
      response = Net::HTTPSuccess.new(1.0, '200', 'OK')
      expect_any_instance_of(Net::HTTP).to receive(:request) { response }
      expect(response).to receive(:body) { empty_data.to_json }  
    end

    it 'raise not found error message' do
      expect {
        subject.perform
      }.to raise_error('Youtube Video is not found') 
    end
  end

  context 'fetch video response is bad request' do
    before do
      response = Net::HTTPBadRequest.new(1.0, '400', 'Bad Request')
      expect_any_instance_of(Net::HTTP).to receive(:request) { response }
    end

    it 'raise fetching error message' do
      expect {
        subject.perform
      }.to raise_error('Can not fetch youtube video info') 
    end
  end
end
