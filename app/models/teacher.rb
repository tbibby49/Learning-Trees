class Teacher < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :students
  has_many :trees

  has_many :tree_shares, dependent: :destroy
  has_many :shared_trees, through: :tree_shares, source: :tree
end
