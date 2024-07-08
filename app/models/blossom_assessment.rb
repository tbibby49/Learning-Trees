class BlossomAssessment < ApplicationRecord
  belongs_to :student
  belongs_to :assessment_item
  belongs_to :blossom
  belongs_to :branch

  validates :stage, presence: true, inclusion: { in: ['Not Evident', 'Partially Demonstrated', 'Fully Demonstrated'] }
  validates :branch_id, presence: true
  validates :blossom_id, presence: true, uniqueness: { scope: [:branch_id, :student_id, :assessment_item_id] }
  validates :student_id, presence: true
  validates :assessment_item_id, presence: true
end
