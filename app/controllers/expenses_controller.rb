class ExpensesController < ApplicationController
  def index
    matching_expenses = Expense.all

    @list_of_expenses = matching_expenses.order({ :created_at => :desc })

    render({ :template => "expense_templates/index" })
  end

  def show
    the_id = params.fetch("path_id")

    matching_expenses = Expense.where({ :id => the_id })

    @the_expense = matching_expenses.at(0)

    render({ :template => "expense_templates/show" })
  end

  def create
    the_expense = Expense.new
    the_expense.description = params.fetch("query_description")
    the_expense.total_amount = params.fetch("query_total_amount")
    the_expense.date = params.fetch("query_date")
    the_expense.notes = params.fetch("query_notes")
    the_expense.payer_id = params.fetch("query_payer_id")
    the_expense.household_id = params.fetch("query_household_id")
    the_expense.category_id = params.fetch("query_category_id")

    if the_expense.valid?
      the_expense.save

      # Create expense splits for each checked member
      split_user_ids = params.fetch("split_user_ids", [])
      split_amount = (the_expense.total_amount / split_user_ids.length).round(2)

      split_user_ids.each do |user_id|
        es = ExpenseSplit.new
        es.expense_id = the_expense.id
        es.user_id = user_id
        es.amount_owed = split_amount
        es.save
      end

      redirect_to("/households/#{the_expense.household_id}", { :notice => "Expense added successfully." })
    else
      redirect_to("/households/#{params.fetch("query_household_id")}", { :alert => the_expense.errors.full_messages.to_sentence })
    end
  end

  def update
    the_id = params.fetch("path_id")
    the_expense = Expense.where({ :id => the_id }).at(0)

    the_expense.description = params.fetch("query_description")
    the_expense.total_amount = params.fetch("query_total_amount")
    the_expense.date = params.fetch("query_date")
    the_expense.notes = params.fetch("query_notes")
    the_expense.payer_id = params.fetch("query_payer_id")
    the_expense.category_id = params.fetch("query_category_id")

    if the_expense.valid?
      the_expense.save
      redirect_to("/expenses/#{the_expense.id}", { :notice => "Expense updated successfully." })
    else
      redirect_to("/expenses/#{the_expense.id}", { :alert => the_expense.errors.full_messages.to_sentence })
    end
  end

  def destroy
    the_id = params.fetch("path_id")
    the_expense = Expense.where({ :id => the_id }).at(0)

    household_id = the_expense.household_id
    the_expense.destroy

    redirect_to("/households/#{household_id}", { :notice => "Expense deleted successfully." })
  end
end
