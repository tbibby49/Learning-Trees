class CreateBlossomAssessments < ActiveRecord::Migration[7.1]
  def change
    create_table :blossom_assessments do |t|
      t.references :student, null: false, foreign_key: true
      t.references :assessment_item, null: false, foreign_key: true
      t.references :blossom, null: false, foreign_key: true
      t.string :stage

      t.timestamps
    end
  end
end
