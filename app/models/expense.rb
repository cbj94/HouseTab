class Expense < ApplicationRecord
  # Direct associations
  belongs_to :payer, required: true, class_name: "User", foreign_key: "payer_id"
  belongs_to :household, required: true, class_name: "Household", foreign_key: "household_id"
  belongs_to :category, required: true, class_name: "Category", foreign_key: "category_id"
  has_many :expense_splits, class_name: "ExpenseSplit", foreign_key: "expense_id", dependent: :destroy

  # Indirect associations
  has_many :beneficiaries, through: :expense_splits, source: :user

  # Validations
  validates :description, presence: true
  validates :total_amount, presence: true, numericality: { greater_than: 0 }
  validates :date, presence: true
end
