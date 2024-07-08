class Student < ApplicationRecord
  has_many :blossom_assessments
  has_many :blossoms, through: :blossom_assessments
  has_many :assessment_items, through: :blossom_assessments
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  belongs_to :teacher

  attribute :teacher_id, :integer
end
