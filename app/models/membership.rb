class Membership < ApplicationRecord
  # Direct associations
  belongs_to :user, required: true, class_name: "User", foreign_key: "user_id"
  belongs_to :household, required: true, class_name: "Household", foreign_key: "household_id", counter_cache: true

  # Validations
  validates :role, presence: true, inclusion: { in: ["creator", "member"] }
  validates :user_id, uniqueness: { scope: :household_id, message: "is already a member of this household" }
end
