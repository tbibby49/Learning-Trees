class Resource < ApplicationRecord
  belongs_to :blossom
  has_one_attached :document
end
