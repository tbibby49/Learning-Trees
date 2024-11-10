class Tree < ApplicationRecord
  belongs_to :teacher
  has_many :branches, dependent: :destroy
  has_many :assessment_items, dependent: :destroy
  has_many :session_goals, dependent: :destroy

  has_many :tree_shares, dependent: :destroy
  has_many :shared_teachers, through: :tree_shares, source: :teacher

  # Scope to retrieve trees accessible by a given teacher
  scope :accessible_by, ->(teacher) {
    where(teacher_id: teacher.id)
    .or(where(id: TreeShare.where(teacher: teacher).select(:tree_id)))
  }

end