class MembershipsController < ApplicationController
  def index
    matching_memberships = Membership.all

    @list_of_memberships = matching_memberships.order({ :created_at => :desc })

    render({ :template => "membership_templates/index" })
  end

  def show
    the_id = params.fetch("path_id")

    matching_memberships = Membership.where({ :id => the_id })

    @the_membership = matching_memberships.at(0)

    render({ :template => "membership_templates/show" })
  end

  def create
    household_id = params.fetch("query_household_id")
    email = params.fetch("query_email")
    role = params.fetch("query_role")

    the_user = User.where({ :email => email }).at(0)

    if the_user == nil
      redirect_to("/households/#{household_id}", { :alert => "No user found with that email. Make sure they've signed up first." })
      return
    end

    the_membership = Membership.new
    the_membership.user_id = the_user.id
    the_membership.household_id = household_id
    the_membership.role = role

    if the_membership.valid?
      the_membership.save
      redirect_to("/households/#{the_membership.household_id}", { :notice => "#{the_user.first_name} added successfully!" })
    else
      redirect_to("/households/#{household_id}", { :alert => the_membership.errors.full_messages.to_sentence })
    end
  end

  def update
    the_id = params.fetch("path_id")
    the_membership = Membership.where({ :id => the_id }).at(0)

    the_membership.user_id = params.fetch("query_user_id")
    the_membership.household_id = params.fetch("query_household_id")
    the_membership.role = params.fetch("query_role")

    if the_membership.valid?
      the_membership.save
      redirect_to("/households/#{the_membership.household_id}", { :notice => "Membership updated successfully." })
    else
      redirect_to("/households/#{the_membership.household_id}", { :alert => the_membership.errors.full_messages.to_sentence })
    end
  end

  def destroy
    the_id = params.fetch("path_id")
    the_membership = Membership.where({ :id => the_id }).at(0)

    household_id = the_membership.household_id
    user_id = the_membership.user_id

    # Check if this member has any outstanding balance
    has_balance = false

    # Check expenses they paid for that others owe on
    their_expenses = Expense.where({ :household_id => household_id, :payer_id => user_id })
    their_expenses.each do |expense|
      splits = ExpenseSplit.where({ :expense_id => expense.id })
      splits.each do |split|
        if split.user_id != user_id
          has_balance = true
        end
      end
    end

    # Check expenses others paid where this member has splits
    all_expenses = Expense.where({ :household_id => household_id })
    all_expenses.each do |expense|
      if expense.payer_id != user_id
        their_split = ExpenseSplit.where({ :expense_id => expense.id, :user_id => user_id }).at(0)
        if their_split != nil
          has_balance = true
        end
      end
    end

    if has_balance
      the_user = User.where({ :id => user_id }).at(0)
      redirect_to("/households/#{household_id}", { :alert => "Cannot remove #{the_user.first_name} — they have outstanding balances. Settle up first." })
    else
      the_membership.destroy
      redirect_to("/households/#{household_id}", { :notice => "Member removed successfully." })
    end
  end
end
