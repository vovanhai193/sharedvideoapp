module VideoService
  YOUTUBE_URL_REGEX = /^.*((youtu.be\/)|(v\/)|(\/u\/\w\/)|(embed\/)|(watch\?))\??v?=?([^#&?]*).*/
  
  class CreateVideo
    def initialize(video)
      @video = video
    end

    def perform
      video_info = FetchYoutubeVideo.new(youtube_id).perform
      video.assign_attributes video_info
      video.save!
      video.reload
    rescue StandardError => e
      video.errors.add(:base, e.message)
      video
    end

    attr_reader :video

    private

    def youtube_id
      match = video.youtube_url.match(YOUTUBE_URL_REGEX)
      raise 'Youtube Url is invalid' unless match && match[7].length==11

      @youtube_id ||= match[7]
    end
  end
end
