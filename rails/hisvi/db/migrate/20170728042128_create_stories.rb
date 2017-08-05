class CreateStories < ActiveRecord::Migration[5.1]
  def change
    create_table :stories do |t|
      t.references :user, foreign_key: true
      t.references :cateogry, foreign_key: true
      t.integer :moments
      t.string :title
      t.boolean :is_public

      t.timestamps
    end

    # add_index :stories, :user_id
  end
end
