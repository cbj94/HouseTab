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

    if the_settlement.valid?
      the_settlement.save
      redirect_to("/settlements", { :notice => "Settlement created successfully." })
    else
      redirect_to("/settlements", { :alert => the_settlement.errors.full_messages.to_sentence })
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
      redirect_to("/settlements/#{the_settlement.id}", { :notice => "Settlement updated successfully." } )
    else
      redirect_to("/settlements/#{the_settlement.id}", { :alert => the_settlement.errors.full_messages.to_sentence })
    end
  end

  def destroy
    the_id = params.fetch("path_id")
    the_settlement = Settlement.where({ :id => the_id }).at(0)

    the_settlement.destroy

    redirect_to("/settlements", { :notice => "Settlement deleted successfully." } )
  end
end
