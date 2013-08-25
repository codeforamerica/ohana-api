OhanaApi::Application.routes.draw do

  devise_for :admins
  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'

	devise_for :users
  resources :api_applications, except: :show
  get "api_applications/:id" => "api_applications#edit"

  root :to => "home#index"

  mount API::Root => '/'

  get 'api/docs' => 'api_docs#index'
end
