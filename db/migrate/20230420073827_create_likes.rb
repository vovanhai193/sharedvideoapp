class CreateLikes < ActiveRecord::Migration[7.0]
  def change
    create_table :likes do |t|
      t.references :user
      t.references :video
      t.boolean :is_like

      t.timestamps
    end
  end
end
