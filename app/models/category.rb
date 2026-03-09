class Category < ApplicationRecord
  # Direct associations
  belongs_to :household, required: false, class_name: "Household", foreign_key: "household_id"
  has_many :expenses, class_name: "Expense", foreign_key: "category_id", dependent: :destroy

  # Validations
  validates :name, presence: true
end
