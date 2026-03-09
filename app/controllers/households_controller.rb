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

    render({ :template => "household_templates/show" })
  end

  def create
    the_household = Household.new
    the_household.name = params.fetch("query_name")

    if the_household.valid?
      the_household.save
      redirect_to("/households", { :notice => "Household created successfully." })
    else
      redirect_to("/households", { :alert => the_household.errors.full_messages.to_sentence })
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

    redirect_to("/households", { :notice => "Household deleted successfully." } )
  end
end
