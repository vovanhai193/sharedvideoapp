class CreateVideos < ActiveRecord::Migration[7.0]
  def change
    create_table :videos do |t|
      t.references :user
      t.string :youtube_url
      t.string :youtube_id
      t.string :title
      t.string :description
      t.integer :like_count, default: 0
      t.integer :unlike_count, default: 0

      t.timestamps
    end
  end
end
