Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'home#index'

  # Example of regular route:
  get 'dashboard' => 'dashboard#index'
  post 'token/generate' => 'token#generate'
  post 'call/connect' => 'call#connect'
  post 'conference' => 'call#showConferenceStatus'

  post 'users/requestcode' => 'users#request_code'
  post 'users/showalluser' => 'users#show_all_user'
  post 'users/update' => 'users#update'
  post 'users/clear' => 'users#clear_data_user'
  post 'users/verifycode' => 'users#verify_code'
  post 'users/requestgcm' => 'users#making_request_to_gcm'
  post 'users/updatelocation' => 'users#update_location'
  post 'users/callphonenumbers' => 'users#callclient'

  post 'users/callconference' => 'users#twilio'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  resources :tickets, only: [:create]

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
