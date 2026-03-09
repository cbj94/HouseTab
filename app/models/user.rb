class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Direct associations
  has_many :memberships, class_name: "Membership", foreign_key: "user_id", dependent: :destroy
  has_many :expense_splits, class_name: "ExpenseSplit", foreign_key: "user_id", dependent: :destroy
  has_many :expenses, class_name: "Expense", foreign_key: "payer_id", dependent: :destroy
  has_many :settlements_as_payer, class_name: "Settlement", foreign_key: "payer_id", dependent: :destroy
  has_many :settlements_as_payee, class_name: "Settlement", foreign_key: "payee_id", dependent: :destroy

  # Indirect associations
  has_many :joined_households, through: :memberships, source: :household
  has_many :owed_expenses, through: :expense_splits, source: :expense

  # Validations
  validates :first_name, presence: true
  validates :last_name, presence: true
end
