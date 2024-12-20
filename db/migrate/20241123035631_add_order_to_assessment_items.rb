class AddOrderToAssessmentItems < ActiveRecord::Migration[7.1]
  def change
    add_column :assessment_items, :order, :integer
  end
end
