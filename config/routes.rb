Rails.application.routes.draw do
  ActiveAdmin.routes(self)
  post '/login'  => 'session#create'
  get  '/logout' => 'session#create'

  get '/rsvp' => 'site#rsvp'
  put '/rsvp' => 'site#update_rsvp'

  root to: 'site#index'
end
