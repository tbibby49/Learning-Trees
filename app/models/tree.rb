class Tree < ApplicationRecord
  has_many :branches, dependent: :destroy
  has_many :assessment_items, dependent: :destroy
end
