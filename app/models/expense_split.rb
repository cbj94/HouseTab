class ExpenseSplit < ApplicationRecord
  # Direct associations
  belongs_to :expense, required: true, class_name: "Expense", foreign_key: "expense_id"
  belongs_to :user, required: true, class_name: "User", foreign_key: "user_id"

  # Validations
  validates :amount_owed, presence: true, numericality: { greater_than: 0 }
end
