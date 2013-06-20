require 'api_constraints'

OhanaApi::Application.routes.draw do

	devise_for :users
  resources :api_applications, only: [:index, :new, :edit, :create, :update, :destroy]
  get "api_applications/:id" => "api_applications#edit"
  root :to => "home#index"

	namespace :api, defaults: {format: 'json'} do
    scope module: :v1, constraints: ApiConstraints.new(1) do
      resources :organizations
  		get 'search', :to => 'organizations#search'
		end
  end
end
