class AssessmentItem < ApplicationRecord
  belongs_to :tree
  has_many :blossom_assessments
  has_many :blossoms, through: :blossom_assessments
  has_many :students, through: :blossom_assessments

  has_one_attached :document

  validates :name, presence: true

  before_create :set_default_order

  private

  def set_default_order
    self.order ||= tree.assessment_items.maximum(:order).to_i + 1
  end

  def purge_document
    document.purge if document.attached?
  end

end
