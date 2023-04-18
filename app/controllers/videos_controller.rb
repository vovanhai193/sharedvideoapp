class VideosController < ApplicationController
  skip_before_action :authenticate_user!, only: :index

  def index
    render plain: 'OK'
  end
end
