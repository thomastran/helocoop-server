Rails.application.routes.draw do
  ActiveAdmin.routes(self)
  devise_for :authentications, controllers: {
        sessions: 'authentication/sessions'
  }
  # devise_for :authentications

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'admin/users#index'
  get 'go' => 'admin/users#go'
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
  post 'users/updatelocation' => 'users#update_location'
  post 'users/callphonenumbers' => 'users#callclient'
  post 'users/callconference' => 'users#twilio'
  get 'phoneconference' => 'phoneconference#index'
  post 'phoneconference' => 'phoneconference#index'
  post 'phoneconference/create' => 'phoneconference#create'
  post 'users/turnon' => 'users#turn_on_samaritan'
  post 'users/turnoff' => 'users#turn_off_samaritan'
  post 'users/createdatatest' => 'users#create_data_test'
  post 'users/findpeopletocall' => 'users#find_people_to_call'
  post 'users/makeconferencecall' => 'users#make_conference_call'
  get 'users/learn' => 'users#learn_ruby'
  post 'users/updatelocationservice' => 'users#update_location_service'

  post 'authentication' => 'authentication#create'
  post 'users/changeinfo' => 'users#change_info'

  post 'users/log' => 'users#log_conference_call'
  post 'users/rating' => 'users#rating'
  post 'users/getinstanceid' => 'users#get_instance_id'

  # Voip Branch
  post 'voip/requestcode' => 'voip#request_code'
  post 'voip/verifycode' => 'voip#verify_code'
  post 'voip/update' => 'voip#update'
  post 'voip/updatelocationservice' => 'voip#update_location_service'
  post 'voip/getinstanceid' => 'voip#get_instance_id'
  post 'voip/updatelocation' => 'voip#update_location'
  post 'voip/changeinfo' => 'voip#change_info'
  post 'voip/turnon' => 'voip#turn_on_samaritan'
  post 'voip/turnoff' => 'voip#turn_off_samaritan'

  post 'voip/generatetoken' => 'voip#generate_token'
  post 'voip/makeconferencecall' => 'voip#make_conference_call'
  post 'voip/connect' => 'voip#connect'


  # Example of named routfe that can be invoked with purchase_url(id: product.id)
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
