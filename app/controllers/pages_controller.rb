class PagesController < ApplicationController
  def home
    @memberships = current_user.memberships
    @households = current_user.joined_households

    if @households.count == 1
      redirect_to("/households/#{@households.first.id}")
    end
  end
end
