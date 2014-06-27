require 'api_constraints'
require 'docs_subdomain'
require 'api_subdomain'

Rails.application.routes.draw do
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
          resources :address, except: [:index, :show]
          resources :mail_address, except: [:index, :show]
          resources :contacts, except: [:show]
          resources :faxes, except: [:show]
          resources :phones, except: [:show]
          resources :services
        end
        resources :search, only: :index
        resources :categories, only: :index
        resources :organizations
        put 'services/:service_id/categories' => 'services#update_categories'
        get 'categories/:oe_id/children' => 'categories#children'
        get 'locations/:location_id/nearby' => 'search#nearby'
        get 'organizations/:organization_id/locations' => 'organizations#locations'

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
end
