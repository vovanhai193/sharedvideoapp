class AddIsLikeIndex < ActiveRecord::Migration[7.0]
  def change
    add_index :likes, :is_like
  end
end
