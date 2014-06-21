require 'api_constraints'
require 'docs_subdomain'
require 'api_subdomain'

OhanaApi::Application.routes.draw do
  # The priority is based upon order of creation:
  # first created -> highest priority.
  # See how all your routes lay out with 'rake routes'.
  # Read more about routing: http://guides.rubyonrails.org/routing.html

  devise_for :users

  resources :api_applications, except: :show
  get 'api_applications/:id' => 'api_applications#edit'

  root to: 'home#index'

  constraints(DocsSubdomain) do
    get 'docs' => 'api_docs#index'
  end

  constraints(ApiSubdomain) do
    namespace :api, path: SETTINGS[:api_path], defaults: { format: 'json' } do
      scope module: :v1, constraints: ApiConstraints.new(version: 1) do
        resources :locations do
          resources :address, only: [:update, :create, :destroy]
          resources :mail_address, only: [:update, :create, :destroy]
          resources :contacts, only: [:update, :create, :destroy]
          resources :faxes, only: [:update, :create, :destroy]
          resources :phones, only: [:update, :create, :destroy]
          resources :services
        end
        resources :search, only: :index
        resources :categories, only: :index
        resources :organizations
        put 'services/:services_id/categories' => 'services#update_categories'
        get 'categories/:category_id/children' => 'categories#children'
        get 'locations/:location_id/nearby' => 'search#nearby'

        match '*unmatched_route' => 'errors#raise_not_found!', via: [:patch, :get, :post, :put, :delete]

        # CORS support
        match '*foo' => 'cors#render_204', via: [:options]
      end
    end
  end

  get '.well-known/status' => 'status#check_status'

  # default_url_options host: ENV['API_BASE_HOST']
end
