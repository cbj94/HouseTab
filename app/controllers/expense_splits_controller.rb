class ExpenseSplitsController < ApplicationController
  def index
    matching_expense_splits = ExpenseSplit.all

    @list_of_expense_splits = matching_expense_splits.order({ :created_at => :desc })

    render({ :template => "expense_split_templates/index" })
  end

  def show
    the_id = params.fetch("path_id")

    matching_expense_splits = ExpenseSplit.where({ :id => the_id })

    @the_expense_split = matching_expense_splits.at(0)

    render({ :template => "expense_split_templates/show" })
  end

  def create
    the_expense_split = ExpenseSplit.new
    the_expense_split.expense_id = params.fetch("query_expense_id")
    the_expense_split.user_id = params.fetch("query_user_id")
    the_expense_split.amount_owed = params.fetch("query_amount_owed")

    if the_expense_split.valid?
      the_expense_split.save
      redirect_to("/expense_splits", { :notice => "Expense split created successfully." })
    else
      redirect_to("/expense_splits", { :alert => the_expense_split.errors.full_messages.to_sentence })
    end
  end

  def update
    the_id = params.fetch("path_id")
    the_expense_split = ExpenseSplit.where({ :id => the_id }).at(0)

    the_expense_split.expense_id = params.fetch("query_expense_id")
    the_expense_split.user_id = params.fetch("query_user_id")
    the_expense_split.amount_owed = params.fetch("query_amount_owed")

    if the_expense_split.valid?
      the_expense_split.save
      redirect_to("/expense_splits/#{the_expense_split.id}", { :notice => "Expense split updated successfully." } )
    else
      redirect_to("/expense_splits/#{the_expense_split.id}", { :alert => the_expense_split.errors.full_messages.to_sentence })
    end
  end

  def destroy
    the_id = params.fetch("path_id")
    the_expense_split = ExpenseSplit.where({ :id => the_id }).at(0)

    the_expense_split.destroy

    redirect_to("/expense_splits", { :notice => "Expense split deleted successfully." } )
  end
end
