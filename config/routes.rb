OhanaApi::Application.routes.draw do
  # The priority is based upon order of creation:
  # first created -> highest priority.
  # See how all your routes lay out with 'rake routes'.

  # Read more about routing: http://guides.rubyonrails.org/routing.html

  devise_for :users

  resources :api_applications, except: :show
  get 'api_applications/:id' => 'api_applications#edit'

  root to: 'home#index'

  mount API::Root => '/'

  get 'api/docs' => 'api_docs#index'

  get '.well-known/status' => 'status#check_status'

  default_url_options host: ENV['API_BASE_HOST']
end
