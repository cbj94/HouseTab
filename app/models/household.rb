class Household < ApplicationRecord
  # Direct associations
  has_many :memberships, class_name: "Membership", foreign_key: "household_id", dependent: :destroy
  has_many :categories, class_name: "Category", foreign_key: "household_id", dependent: :destroy
  has_many :expenses, class_name: "Expense", foreign_key: "household_id", dependent: :destroy
  has_many :settlements, class_name: "Settlement", foreign_key: "household_id", dependent: :destroy

  # Indirect associations
  has_many :members, through: :memberships, source: :user

  # Validations
  validates :name, presence: true
end
