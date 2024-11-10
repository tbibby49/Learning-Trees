class AddTeacherIdToTrees < ActiveRecord::Migration[7.1]
  def change
    add_column :trees, :teacher_id, :integer
  end
end
