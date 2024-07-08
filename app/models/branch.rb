class Branch < ApplicationRecord
  belongs_to :tree
  has_many :blossoms, dependent: :destroy
  has_many :blossom_assessments
end
