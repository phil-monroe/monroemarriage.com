class SessionController < ApplicationController
  def create
    household = Household.find_by(rsvp_code: params[:rsvp_code])

    if household.present?
      session[:household_id] = household.id
      household.touch :logged_in_at
      redirect_to rsvp_path

    else
      flash[:error] = "Unknown RSVP code."
      redirect_to root_path
    end
  end


  def destroy
    session.clear
    redirect_to root_path
  end
end