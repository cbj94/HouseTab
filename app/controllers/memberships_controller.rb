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
    the_membership.destroy

    redirect_to("/households/#{household_id}", { :notice => "Member removed successfully." })
  end
end
