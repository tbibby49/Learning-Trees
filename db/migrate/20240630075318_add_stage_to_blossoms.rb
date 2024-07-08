class AddStageToBlossoms < ActiveRecord::Migration[7.1]
  def change
    add_column :blossoms, :stage, :string
  end
end
