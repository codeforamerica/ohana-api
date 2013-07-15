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
      resources :organizations
  		get 'search', :to => 'organizations#search'
      get 'organizations/:id/nearby', :to => 'organizations#nearby'
		end
  end
end
