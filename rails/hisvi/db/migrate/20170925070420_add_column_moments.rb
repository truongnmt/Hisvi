class AddColumnMoments < ActiveRecord::Migration[5.1]
  def change
    add_column :moments, :image, :text
    add_column :stories, :image, :text
  end
end
