class AddClassIdToStudents < ActiveRecord::Migration[7.1]
  def change
    add_column :students, :class_id, :string
  end
end
