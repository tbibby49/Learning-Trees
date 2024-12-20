class Blossom < ApplicationRecord
  belongs_to :branch

  has_many :blossom_assessments, dependent: :destroy
  has_many :students, through: :blossom_assessments
  has_many :assessment_items, through: :blossom_assessments

  validates :name, presence: true

  has_many :resources, dependent: :destroy
  accepts_nested_attributes_for :resources, allow_destroy: true


end
