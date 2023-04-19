class VideosController < ApplicationController
  skip_before_action :authenticate_user!, only: :index

  def index
    @videos = Video.includes(:user).order(id: :desc).page(params[:page])
  end

  def new
    @video = Video.new
  end

  def create
    @video = current_user.videos.new video_params
    @video = VideoService::CreateVideo.new(@video).perform
    if @video.errors.empty?
      flash[:notice] = 'Shared movie successfully!'
      redirect_to root_path
    else
      flash.now[:alert] = @video.errors.full_messages.join(', ')
      render :new, status: :unprocessable_entity
    end
  end

  private

  def video_params
    params.require(:video).permit(:youtube_url)
  end
end
