require 'net/http'

module VideoService
  class FetchYoutubeVideo
    def initialize(youtube_id)
      @youtube_id = youtube_id
    end

    def perform
      data = fetch_info

      raise 'Youtube Video is not found' if data['items'].empty?

      {
        youtube_id: youtube_id,
        title: data['items'].first&.dig('snippet', 'title'),
        description: data['items'].first&.dig('snippet', 'description')
      }
    end

    private

    attr_reader :youtube_id

    def fetch_info
      uri = URI(youtube_api_url)
      res = Net::HTTP.get_response(uri)
      raise 'Can not fetch youtube video info' unless res.is_a?(Net::HTTPSuccess)
  
      JSON.parse(res.body)
    end

    def youtube_api_url
      "#{ENV['YOUTUBE_API_URL']}?part=snippet&key=#{youtube_api_key}&id=#{youtube_id}"
    end

    def youtube_api_key
      ENV['YOUTUBE_API_KEY']
    end
  end
end
