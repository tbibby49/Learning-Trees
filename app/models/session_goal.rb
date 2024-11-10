class SessionGoal < ApplicationRecord
  belongs_to :student
  belongs_to :tree

  has_one_attached :document

  validates :goal, presence: true
  validates :self_assess, inclusion: { in: 1..5 }
end
