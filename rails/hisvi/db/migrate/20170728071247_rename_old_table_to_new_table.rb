class RenameOldTableToNewTable < ActiveRecord::Migration[5.1]
  def change
    rename_table :cateogries, :categories
  end
end
