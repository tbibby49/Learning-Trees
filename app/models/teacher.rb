class Teacher < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :students
  has_many :trees

  has_many :tree_shares, dependent: :destroy
  has_many :shared_trees, through: :tree_shares, source: :tree

  validate :email_domain_allowed

  private

  def email_domain_allowed
    allowed_domains = ["sec.act.edu.au"]
    domain = email.split("@").last
    errors.add(:email, "must be from an allowed domain") unless allowed_domains.include?(domain)
  end
end
