OhanaApi::Application.routes.draw do

	devise_for :users
  resources :api_applications, except: :show
  get "api_applications/:id" => "api_applications#edit"

  root :to => "home#index"

  mount API::Root => '/'

  get 'api/docs' => 'api_docs#index'

  get '.well-known/status' => "status#get_status"

  default_url_options host: Rails.application.config.api_base_host
end
