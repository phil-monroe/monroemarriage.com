class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  http_basic_authenticate_with :name => ENV["ADMIN_USER"], :password => ENV["ADMIN_PASSWORD"], :if => :admin_controller?

  def admin_controller?
    self.class < ActiveAdmin::BaseController
  end

  helper_method def current_household
    return @current_household unless @current_household.nil?
    @current_household ||= Household.find(session[:household_id]) rescue false
  end
end
