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
      redirect_to("/expenses", { :notice => "Expense created successfully." })
    else
      redirect_to("/expenses", { :alert => the_expense.errors.full_messages.to_sentence })
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
    the_expense.household_id = params.fetch("query_household_id")
    the_expense.category_id = params.fetch("query_category_id")

    if the_expense.valid?
      the_expense.save
      redirect_to("/expenses/#{the_expense.id}", { :notice => "Expense updated successfully." } )
    else
      redirect_to("/expenses/#{the_expense.id}", { :alert => the_expense.errors.full_messages.to_sentence })
    end
  end

  def destroy
    the_id = params.fetch("path_id")
    the_expense = Expense.where({ :id => the_id }).at(0)

    the_expense.destroy

    redirect_to("/expenses", { :notice => "Expense deleted successfully." } )
  end
end
