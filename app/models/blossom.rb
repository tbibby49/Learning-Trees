class Blossom < ApplicationRecord
  belongs_to :branch

  has_many :blossom_assessments
  has_many :students, through: :blossom_assessments
  has_many :assessment_items, through: :blossom_assessments

  validates :name, presence: true

end
