require 'api_constraints'
require 'subdomain_constraints'

Rails.application.routes.draw do
  # The priority is based upon order of creation:
  # first created -> highest priority.
  # See how all your routes lay out with 'rake routes'.
  # Read more about routing: http://guides.rubyonrails.org/routing.html

  devise_for :users, controllers: { registrations: 'user/registrations' }
  devise_for :admins, path: ENV['ADMIN_PATH'] || '/', controllers: { registrations: 'admin/registrations' }

  constraints(SubdomainConstraints.new(subdomain: ENV['ADMIN_SUBDOMAIN'])) do
    namespace :admin, path: ENV['ADMIN_PATH'] do
      root to: 'dashboard#index', as: :dashboard

      resources :locations, except: :show do
        resources :services, except: [:show, :index]
        resources :contacts, except: [:show, :index]
      end

      resources :organizations, except: :show
      resources :programs, except: :show
      resources :services, only: :index

      get 'locations/:location_id/services/confirm_delete_service', to: 'services#confirm_delete_service', as: :confirm_delete_service
      get 'organizations/confirm_delete_organization', to: 'organizations#confirm_delete_organization', as: :confirm_delete_organization
      get 'locations/confirm_delete_location', to: 'locations#confirm_delete_location', as: :confirm_delete_location
      get 'programs/confirm_delete_program', to: 'programs#confirm_delete_program', as: :confirm_delete_program

      get 'locations/:location_id/services/:id', to: 'services#edit'
      get 'locations/:location_id/contacts/:id', to: 'contacts#edit'
      get 'locations/:id', to: 'locations#edit'
      get 'organizations/:id', to: 'organizations#edit'
      get 'programs/:id', to: 'programs#edit'
    end
  end

  resources :api_applications, except: :show
  get 'api_applications/:id' => 'api_applications#edit'

  constraints(SubdomainConstraints.new(subdomain: ENV['API_SUBDOMAIN'])) do
    namespace :api, path: ENV['API_PATH'], defaults: { format: 'json' } do
      scope module: :v1, constraints: ApiConstraints.new(version: 1) do
        get '/' => 'root#index'
        get '.well-known/status' => 'status#check_status'

        resources :organizations do
          resources :locations, only: :create
        end
        get 'organizations/:organization_id/locations', to: 'organizations#locations', as: :org_locations

        resources :locations do
          resources :address, except: [:index, :show]
          resources :mail_address, except: [:index, :show]
          resources :contacts, except: [:show] do
            resources :phones, except: [:show, :index], path: '/phones', controller: 'contact_phones'
          end
          resources :phones, except: [:show], path: '/phones', controller: 'location_phones'
          resources :services
        end

        resources :search, only: :index

        resources :categories, only: :index

        put 'services/:service_id/categories', to: 'services#update_categories', as: :service_categories
        get 'categories/:oe_id/children', to: 'categories#children', as: :category_children
        get 'locations/:location_id/nearby', to: 'search#nearby', as: :location_nearby

        match '*unmatched_route' => 'errors#raise_not_found!', via: [:get, :delete, :patch, :post, :put]

        # CORS support
        match '*unmatched_route' => 'cors#render_204', via: [:options]
      end
    end
  end

  root to: 'home#index'
end
