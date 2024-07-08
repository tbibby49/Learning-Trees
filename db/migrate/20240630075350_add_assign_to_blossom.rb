class AddAssignToBlossom < ActiveRecord::Migration[7.1]
  def change
    add_column :blossoms, :assign, :boolean
  end
end
