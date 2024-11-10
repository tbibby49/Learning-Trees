class CreateSessionGoals < ActiveRecord::Migration[7.1]
  def change
    create_table :session_goals do |t|
      t.references :student, null: false, foreign_key: true
      t.references :tree, null: false, foreign_key: true
      t.date :date
      t.text :goal
      t.text :evidence
      t.integer :self_assess

      t.timestamps
    end
  end
end
