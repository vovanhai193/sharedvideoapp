class VideosController < ApplicationController
  skip_before_action :authenticate_user!, only: :index
  before_action :load_video, only: %i(like dislike)


  def index
    @videos = Video.includes(:user, :likes).order(id: :desc).page(params[:page])
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

  def like
    return if @video.liked_by?(current_user)

    respond_to do |format|
      @video.liked_by!(current_user)
      format.html { redirect_to root_path }
      format.js
    end
  end

  def dislike
    return if @video.disliked_by?(current_user)

    respond_to do |format|
      @video.liked_by!(current_user, false)
      format.html { redirect_to root_path }
      format.js
    end
  end

  private

  def load_video
    @video = Video.find(params[:id])
  end

  def video_params
    params.require(:video).permit(:youtube_url)
  end
end
