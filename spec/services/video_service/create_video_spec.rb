require "rails_helper"

describe VideoService::CreateVideo do
  let(:user) { create(:user) }
  let(:youtube_url) { "http://www.youtube.com/watch?v=Ab25nviakcw" }
  let(:video) { build(:video, user: user, youtube_url: youtube_url) }
  let(:video_info) { { youtube_id: "Ab25nviakcw", title: "title", description: "description" } }
  let(:fetch_youtube_video_double) { instance_double(VideoService::FetchYoutubeVideo) }

  before do
    allow(fetch_youtube_video_double).to receive(:perform).and_return(video_info)
  end
  subject { described_class.new(video) }

  shared_examples "valid youtube url" do |youtube_url, expected_youtube_id:|
    let(:youtube_url) { youtube_url }
    before { subject.perform }

    it "should returns correct youtube id" do
      expect(subject.video.youtube_id).to eq(expected_youtube_id)
    end
  end

  context 'fetch youtube video successfully' do
    it_behaves_like 'valid youtube url', "http://www.youtube.com/watch?v=0zM3nApSvMg&feature=feedrec_grec_index", expected_youtube_id: "0zM3nApSvMg"
    it_behaves_like 'valid youtube url', "http://www.youtube.com/user/IngridMichaelsonVEVO#p/a/u/1/QdK8U-VIH_o", expected_youtube_id: "QdK8U-VIH_o"
    it_behaves_like 'valid youtube url', "http://www.youtube.com/v/0zM3nApSvMg?fs=1&amp;hl=en_US&amp;rel=0", expected_youtube_id: "0zM3nApSvMg"
    it_behaves_like 'valid youtube url', "http://www.youtube.com/watch?v=0zM3nApSvMg#t=0m10s", expected_youtube_id: "0zM3nApSvMg"
    it_behaves_like 'valid youtube url', "http://www.youtube.com/embed/0zM3nApSvMg?rel=0", expected_youtube_id: "0zM3nApSvMg"
    it_behaves_like 'valid youtube url', "http://www.youtube.com/watch?v=0zM3nApSvMg", expected_youtube_id: "0zM3nApSvMg"
    it_behaves_like 'valid youtube url', "http://youtu.be/0zM3nApSvMg", expected_youtube_id: "0zM3nApSvMg"
  end
  
  context "when youtube url is invalid" do
    let(:youtube_url) { "invalid_url" }

    it "returns invalid error messages" do
      subject.perform
      expect(subject.video.errors.full_messages).to eq(["Youtube Url is invalid"])
    end
  end

  context "when youtube url is not found" do
    let(:youtube_url) { "http://www.youtube.com/watch?v=not___found" }

    before do
      allow(fetch_youtube_video_double).to receive(:perform).and_raise('Youtube Video is not found')
    end

    it "returns not found error messages" do
      subject.perform
      expect(subject.video.errors.full_messages).to eq(["Youtube Video is not found"])
    end
  end
end
