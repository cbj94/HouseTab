class HouseholdsController < ApplicationController
  def index
    matching_households = Household.all

    @list_of_households = matching_households.order({ :created_at => :desc })

    render({ :template => "household_templates/index" })
  end

  def show
    the_id = params.fetch("path_id")

    matching_households = Household.where({ :id => the_id })

    @the_household = matching_households.at(0)

    # Make sure current user is a member of this household
    membership = Membership.where({ :user_id => current_user.id, :household_id => @the_household.id }).at(0)

    if membership == nil
      redirect_to("/", { :alert => "You are not a member of that household." })
    else
      @membership = membership
      @expenses = Expense.where({ :household_id => @the_household.id }).order({ :date => :desc })
      @members = @the_household.members
      @settlements = Settlement.where({ :household_id => @the_household.id }).order({ :date => :desc })

      # Calculate balances for current user vs each other member
      @balances = {}

      @members.each do |member|
        next if member.id == current_user.id

        # What I owe them: my splits on expenses they paid for
        i_owe_them = 0.0
        their_expenses = Expense.where({ :household_id => @the_household.id, :payer_id => member.id })
        their_expenses.each do |expense|
          my_split = ExpenseSplit.where({ :expense_id => expense.id, :user_id => current_user.id }).at(0)
          if my_split != nil
            i_owe_them = i_owe_them + my_split.amount_owed.to_f
          end
        end

        # What they owe me: their splits on expenses I paid for
        they_owe_me = 0.0
        my_expenses = Expense.where({ :household_id => @the_household.id, :payer_id => current_user.id })
        my_expenses.each do |expense|
          their_split = ExpenseSplit.where({ :expense_id => expense.id, :user_id => member.id }).at(0)
          if their_split != nil
            they_owe_me = they_owe_me + their_split.amount_owed.to_f
          end
        end

        # Settlements I've made to them
        my_payments = Settlement.where({ :household_id => @the_household.id, :payer_id => current_user.id, :payee_id => member.id })
        my_payments.each do |settlement|
          i_owe_them = i_owe_them - settlement.amount.to_f
        end

        # Settlements they've made to me
        their_payments = Settlement.where({ :household_id => @the_household.id, :payer_id => member.id, :payee_id => current_user.id })
        their_payments.each do |settlement|
          they_owe_me = they_owe_me - settlement.amount.to_f
        end

        # Net balance: positive means I owe them, negative means they owe me
        net = i_owe_them - they_owe_me

        @balances[member] = net.round(2)
      end

      render({ :template => "household_templates/show" })
    end
  end

  def create
    the_household = Household.new
    the_household.name = params.fetch("query_name")

    if the_household.valid?
      the_household.save

      # Automatically make the current user the creator
      membership = Membership.new
      membership.user_id = current_user.id
      membership.household_id = the_household.id
      membership.role = "creator"
      membership.save

      redirect_to("/households/#{the_household.id}", { :notice => "Household created successfully." })
    else
      redirect_to("/", { :alert => the_household.errors.full_messages.to_sentence })
    end
  end

  def update
    the_id = params.fetch("path_id")
    the_household = Household.where({ :id => the_id }).at(0)

    the_household.name = params.fetch("query_name")

    if the_household.valid?
      the_household.save
      redirect_to("/households/#{the_household.id}", { :notice => "Household updated successfully." } )
    else
      redirect_to("/households/#{the_household.id}", { :alert => the_household.errors.full_messages.to_sentence })
    end
  end

  def destroy
    the_id = params.fetch("path_id")
    the_household = Household.where({ :id => the_id }).at(0)

    the_household.destroy

    redirect_to("/", { :notice => "Household deleted successfully." } )
  end
end
