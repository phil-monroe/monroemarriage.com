class SiteController < ApplicationController
  before_action :require_household, only: [:rsvp, :update_rsvp]

  def index
    redirect_to rsvp_path if current_household.present?
  end




  def rsvp
    @people = current_household.people.order('first_name')
  end

  def update_rsvp
    ActiveRecord::Base.transaction do
      current_household.people.update_all attending: false
      current_household.people.where(id: params["attendees"]).update_all attending: true
    end

    render nothing: true
  end



  private

  def require_household
    redirect_to root_path unless current_household.present?
  end
end