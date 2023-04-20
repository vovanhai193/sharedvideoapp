class Like < ApplicationRecord
  belongs_to :user
  belongs_to :video

  after_save :update_counter!

  private

  def update_counter!
    video.like_count = video.likes.where(is_like: true).count
    video.unlike_count = video.likes.where(is_like: false).count
    video.save!
  end
end
