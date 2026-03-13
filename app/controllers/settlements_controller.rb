class SettlementsController < ApplicationController
  def index
    matching_settlements = Settlement.all

    @list_of_settlements = matching_settlements.order({ :created_at => :desc })

    render({ :template => "settlement_templates/index" })
  end

  def show
    the_id = params.fetch("path_id")

    matching_settlements = Settlement.where({ :id => the_id })

    @the_settlement = matching_settlements.at(0)

    render({ :template => "settlement_templates/show" })
  end

  def create
  the_settlement = Settlement.new
  the_settlement.payer_id = params.fetch("query_payer_id")
  the_settlement.payee_id = params.fetch("query_payee_id")
  the_settlement.household_id = params.fetch("query_household_id")
  the_settlement.amount = params.fetch("query_amount")
  the_settlement.date = params.fetch("query_date")
  the_settlement.notes = params.fetch("query_notes")

  # Recalculate how much payer actually owes payee
  household_id = params.fetch("query_household_id")
  payer_id = params.fetch("query_payer_id").to_i
  payee_id = params.fetch("query_payee_id").to_i

  # What payer owes payee from payee's expenses
  i_owe_them = 0.0
  their_expenses = Expense.where({ :household_id => household_id, :payer_id => payee_id })
  their_expenses.each do |expense|
    my_split = ExpenseSplit.where({ :expense_id => expense.id, :user_id => payer_id }).at(0)
    if my_split != nil
      i_owe_them = i_owe_them + my_split.amount_owed.to_f
    end
  end

  # What payee owes payer from payer's expenses
  they_owe_me = 0.0
  my_expenses = Expense.where({ :household_id => household_id, :payer_id => payer_id })
  my_expenses.each do |expense|
    their_split = ExpenseSplit.where({ :expense_id => expense.id, :user_id => payee_id }).at(0)
    if their_split != nil
      they_owe_me = they_owe_me + their_split.amount_owed.to_f
    end
  end

  # Subtract existing settlements
  my_payments = Settlement.where({ :household_id => household_id, :payer_id => payer_id, :payee_id => payee_id })
  my_payments.each do |settlement|
    i_owe_them = i_owe_them - settlement.amount.to_f
  end

  their_payments = Settlement.where({ :household_id => household_id, :payer_id => payee_id, :payee_id => payer_id })
  their_payments.each do |settlement|
    they_owe_me = they_owe_me - settlement.amount.to_f
  end

  max_owed = [(i_owe_them - they_owe_me).round(2), 0].max

  if the_settlement.amount.to_f > max_owed
    redirect_to("/households/#{household_id}", { :alert => "You can't pay more than you owe ($#{sprintf('%.2f', max_owed)})." })
  elsif the_settlement.valid?
    the_settlement.save
    redirect_to("/households/#{the_settlement.household_id}", { :notice => "Payment recorded successfully." })
  else
    redirect_to("/households/#{params.fetch("query_household_id")}", { :alert => the_settlement.errors.full_messages.to_sentence })
  end
end

  def update
    the_id = params.fetch("path_id")
    the_settlement = Settlement.where({ :id => the_id }).at(0)

    the_settlement.payer_id = params.fetch("query_payer_id")
    the_settlement.payee_id = params.fetch("query_payee_id")
    the_settlement.household_id = params.fetch("query_household_id")
    the_settlement.amount = params.fetch("query_amount")
    the_settlement.date = params.fetch("query_date")
    the_settlement.notes = params.fetch("query_notes")

    if the_settlement.valid?
      the_settlement.save
      redirect_to("/households/#{the_settlement.household_id}", { :notice => "Settlement updated successfully." })
    else
      redirect_to("/households/#{the_settlement.household_id}", { :alert => the_settlement.errors.full_messages.to_sentence })
    end
  end

  def destroy
    the_id = params.fetch("path_id")
    the_settlement = Settlement.where({ :id => the_id }).at(0)

    household_id = the_settlement.household_id
    the_settlement.destroy

    redirect_to("/households/#{household_id}", { :notice => "Settlement deleted successfully." })
  end
end
