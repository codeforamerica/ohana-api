require 'api_constraints'
require 'subdomain_constraints'

Rails.application.routes.draw do
  # The priority is based upon order of creation:
  # first created -> highest priority.
  # See how all your routes lay out with 'rake routes'.
  # Read more about routing: http://guides.rubyonrails.org/routing.html

  controller :welcome do
    get "/welcome" => "welcome#home", as: :welcome
  end

  devise_for :users, controllers: { registrations: 'user/registrations' }
  devise_for :admins, path: ENV['ADMIN_PATH'] || '/', controllers: { registrations: 'admin/registrations' }

  constraints(SubdomainConstraints.new(subdomain: ENV['ADMIN_SUBDOMAIN'])) do
    namespace :admin, path: ENV['ADMIN_PATH'] do
      root to: 'dashboard#index', as: :dashboard

      resources :locations, except: :show do
        resources :services, except: [:show, :index]
      end

      resources :organizations, except: :show

      get 'locations/:location_id/services/confirm_delete_service', to: 'services#confirm_delete_service', as: :confirm_delete_service
      get 'organizations/confirm_delete_organization', to: 'organizations#confirm_delete_organization', as: :confirm_delete_organization
      get 'locations/confirm_delete_location', to: 'locations#confirm_delete_location', as: :confirm_delete_location

      get 'locations/:location_id/services/:id', to: 'services#edit'
      get 'locations/:id', to: 'locations#edit'
      get 'organizations/:id', to: 'organizations#edit'
    end
  end

  resources :api_applications, except: :show
  get 'api_applications/:id' => 'api_applications#edit'

  constraints(SubdomainConstraints.new(subdomain: ENV['API_SUBDOMAIN'])) do
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
        put 'services/:service_id/categories', to: 'services#update_categories', as: :service_categories
        get 'categories/:oe_id/children', to: 'categories#children', as: :category_children
        get 'locations/:location_id/nearby', to: 'search#nearby', as: :location_nearby
        get 'organizations/:organization_id/locations', to: 'organizations#locations', as: :organization_locations

        match '*unmatched_route' => 'errors#raise_not_found!', via: [:get, :delete, :patch, :post, :put]

        # CORS support
        match '*unmatched_route' => 'cors#render_204', via: [:options]
      end
    end
  end

  constraints(SubdomainConstraints.new(subdomain: ENV['DEV_SUBDOMAIN'])) do
    get 'docs' => 'api_docs#index'
  end

  root to: 'home#index'

  get '.well-known/status' => 'status#check_status'
end
