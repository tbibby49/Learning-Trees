class CreateTreeShares < ActiveRecord::Migration[7.1]
  def change
    create_table :tree_shares do |t|
      t.references :tree, null: false, foreign_key: true
      t.references :teacher, null: false, foreign_key: true

      t.timestamps
    end
  end
end
