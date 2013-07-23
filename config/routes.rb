require 'api_constraints'

OhanaApi::Application.routes.draw do

	devise_for :users

  resources :api_applications, except: :show
  get "api_applications/:id" => "api_applications#edit"
  root :to => "home#index"

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

	namespace :api, defaults: {format: 'json'} do
    scope module: :v1, constraints: ApiConstraints.new(1) do
      resources :organizations do
        resources :locations, shallow: true
      end

      resources :locations
  		get 'search', :to => 'locations#search'
      get 'locations/:id/nearby', :to => 'locations#nearby'
		end
  end
end
