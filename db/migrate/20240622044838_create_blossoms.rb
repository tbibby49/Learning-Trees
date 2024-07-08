class CreateBlossoms < ActiveRecord::Migration[7.1]
  def change
    create_table :blossoms do |t|
      t.string :name
      t.text :description
      t.integer :position
      t.integer :row
      t.integer :column
      t.references :branch, null: false, foreign_key: true

      t.timestamps
    end
  end
end
