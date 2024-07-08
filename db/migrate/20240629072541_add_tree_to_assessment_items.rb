class AddTreeToAssessmentItems < ActiveRecord::Migration[7.1]
  def change
    add_reference :assessment_items, :tree, null,: false, foreign_key: true
  end
end
