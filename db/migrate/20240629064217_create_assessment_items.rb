class CreateAssessmentItems < ActiveRecord::Migration[7.1]
  def change
    create_table :assessment_items do |t|
      t.string :name

      t.timestamps
    end
  end
end
