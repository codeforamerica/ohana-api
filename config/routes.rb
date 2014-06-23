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

  constraints(ApiSubdomain) do
    namespace :api, path: ENV['API_PATH'], defaults: { format: 'json' } do
      scope module: :v1, constraints: ApiConstraints.new(version: 1) do
        get '/' => 'root#index'
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

        match '*unmatched_route' => 'errors#raise_not_found!', via: [:get, :delete, :patch, :post, :put]

        # CORS support
        match '*foo' => 'cors#render_204', via: [:options]
      end
    end
  end

  constraints(DocsSubdomain) do
    get 'docs' => 'api_docs#index'
  end

  root to: 'home#index'

  get '.well-known/status' => 'status#check_status'

  # default_url_options host: ENV['API_BASE_HOST']
end
