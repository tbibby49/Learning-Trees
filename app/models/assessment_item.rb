class AssessmentItem < ApplicationRecord
  belongs_to :tree
  has_many :blossom_assessments
  has_many :blossoms, through: :blossom_assessments
  has_many :students, through: :blossom_assessments

  has_one_attached :document

  validates :name, presence: true
end
