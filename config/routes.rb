Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".
  root 'dashboard#index'
  match '/add_users' , to: 'notifications#add_users', via: [:get, :post]
  post '/add_transaction_exchange' => 'notifications#create_transaction_exchange'
  post '/get_saldo' => 'notifications#get_saldo'
  post '/add_saldo' => 'notifications#add_saldo'
  post '/update_users' => 'notifications#update_user'

  # You can have the root of your site routed with "root"
  # root 'welcome#index'
  namespace :api do
    namespace :v1 do
      resources :users, only: [:index, :create, :show, :update, :destroy]
      post '/users/saldos' => 'users#saldos'
      post '/users/saldos_integration' => 'users#saldos_unauthorized'
      get '/info/total', to: 'users#ausers_total'
      post '/users/update/', to: 'users#update_auser'
      post '/users/add_saldo' => 'users#add_saldo'
    end
  end
  post 'authenticate', to: 'authentication#authenticate'
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
