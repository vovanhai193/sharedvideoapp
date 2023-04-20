class Video < ApplicationRecord
  belongs_to :user
  has_many :likes, dependent: :destroy

  def liked_by?(user)
    if likes.loaded?
      likes.any? { |l| l.user_id == user.id && l.is_like? }
    else
      likes.exists?(user: user, is_like: true)
    end
  end

  def disliked_by?(user)
    if likes.loaded?
      likes.any? { |l| l.user_id == user.id && !l.is_like? }
    else
      likes.exists?(user: user, is_like: false)
    end
  end

  def liked_by!(user, is_like = true)
    like = likes.find_or_initialize_by(user: user)
    like.is_like = is_like
    like.save!
  end
end
