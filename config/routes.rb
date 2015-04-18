Rails.application.routes.draw do

  root 'events#new'

  resources :teams
  resources :projects, except: :index
  resources :users, except: :index
  resources :events
  resources :team_requests, only: [:new, :create]

  resource :session, only: [:new, :create, :delete]

  get 'signin', to: 'sessions#new'
  get 'signup', to: 'users#new'
  get 'projects', to: 'teams#index'
  get 'users', to: 'teams#index'
  get 'teams/:id/add_member', to: 'team_requests#new', as: :add_member
  get 'users/:id/report', to: 'users#report'
  get 'projects/:id/report', to: 'projects#report'
  post 'teams/:id/add_member', to: 'team_requests#create'
  post 'teams/:id/leave', to: 'teams#leave', as: :leave_team
  post 'team_requests/accept', to: 'team_requests#accept', as: :accept_team
  post 'team_requests/decline', to: 'team_requests#decline', as: :decline_team
  post 'projects/allocate', to: 'projects#allocate', as: :allocations
  delete 'signout', to: 'sessions#destroy'
  delete 'projects/:id/deallocate', to: 'projects#deallocate', as: :deallocations

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
