class CreateCateogries < ActiveRecord::Migration[5.1]
  def change
    create_table :cateogries do |t|
      t.string :name

      t.timestamps
    end
  end
end
