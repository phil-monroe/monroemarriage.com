Rails.application.routes.draw do
  ActiveAdmin.routes(self)
  post '/login'  => 'session#create'
  get  '/logout' => 'session#destroy'

  get '/rsvp' => 'site#rsvp'
  match '/rsvp' => 'site#update_rsvp', via: [:put, :patch]

  root to: 'site#index'
end
