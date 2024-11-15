class CreateStudentTrees < ActiveRecord::Migration[7.1]
  def change
    create_table :student_trees do |t|
      t.references :student, null: false, foreign_key: true
      t.references :tree, null: false, foreign_key: true

      t.timestamps
    end
  end
end
