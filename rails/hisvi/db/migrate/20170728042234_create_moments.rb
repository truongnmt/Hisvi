class CreateMoments < ActiveRecord::Migration[5.1]
  def change
    create_table :moments do |t|
      t.references :story, foreign_key: true
      t.text :content
      t.boolean :is_completed

      t.timestamps
    end

    # add_index :moments, :story_id
  end
end
