class Settlement < ApplicationRecord
  # Direct associations
  belongs_to :payer, required: true, class_name: "User", foreign_key: "payer_id"
  belongs_to :payee, required: true, class_name: "User", foreign_key: "payee_id"
  belongs_to :household, required: true, class_name: "Household", foreign_key: "household_id"

  # Validations
  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :date, presence: true
  validate :payer_and_payee_are_different

  private

  def payer_and_payee_are_different
    if payer_id == payee_id
      errors.add(:payee_id, "can't be the same as the payer")
    end
  end
end
