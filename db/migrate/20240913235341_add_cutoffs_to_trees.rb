class AddCutoffsToTrees < ActiveRecord::Migration[7.1]
  def change
    add_column :trees, :cutoff_a, :integer
    add_column :trees, :cutoff_b, :integer
    add_column :trees, :cutoff_c, :integer
    add_column :trees, :cutoff_d, :integer
  end
end
