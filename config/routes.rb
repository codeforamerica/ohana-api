require 'api_constraints'

OhanaApi::Application.routes.draw do

  devise_for :admins
  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'

	devise_for :users
  resources :api_applications, except: :show
  get "api_applications/:id" => "api_applications#edit"

  root :to => "home#index"

	namespace :api, defaults: {format: 'json'} do
    scope module: :v1, constraints: ApiConstraints.new(1) do
      # resources :organizations do
      #   resources :programs, shallow: true
      # end
      # resources :programs do
      #   resources :locations, shallow: true
      # end
      resources :organizations
      resources :programs
      resources :locations
  		get 'search', :to => 'locations#search'
      get 'locations/:id/nearby', :to => 'locations#nearby'
		end
  end
end
