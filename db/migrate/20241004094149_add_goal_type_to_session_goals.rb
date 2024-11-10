class AddGoalTypeToSessionGoals < ActiveRecord::Migration[7.1]
  def change
    add_column :session_goals, :goal_type, :string
  end
end
