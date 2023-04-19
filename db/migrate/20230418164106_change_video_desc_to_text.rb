class ChangeVideoDescToText < ActiveRecord::Migration[7.0]
  def change
    change_column :videos, :description, :text
  end
end
