class AddBranchIdToBlossomAssessments < ActiveRecord::Migration[7.1]
  def change
    add_column :blossom_assessments, :branch_id, :integer
  end
end
