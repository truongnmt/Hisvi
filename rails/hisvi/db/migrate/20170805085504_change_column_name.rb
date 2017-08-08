class ChangeColumnName < ActiveRecord::Migration[5.1]
  if Story.column_names.include?("cateogry_id")
    def change
      rename_column :stories, :cateogry_id, :category_id
    end
  end
end
