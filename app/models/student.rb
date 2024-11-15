class Student < ApplicationRecord
  has_many :blossom_assessments
  has_many :blossoms, through: :blossom_assessments
  has_many :assessment_items, through: :blossom_assessments
  has_many :session_goals, dependent: :destroy
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  belongs_to :teacher
  has_many :class_ids
  has_many :student_trees
  has_many :teachers
  has_many :trees, through: :student_trees

  attribute :teacher_id, :integer
end
