Paperclip::Application.routes.draw do

  # This line mounts Forem's routes at /forums by default.
  # This means, any requests to the /forums URL of your application will go to Forem::ForumsController#index.
  # If you would like to change where this extension is mounted, simply change the :at option to something different.
  #
  # We ask that you don't use the :as option here, as Forem relies on it being the default of "forem"
  mount Forem::Engine, :at => '/forums'


  resources :subscriptions, only: [:index, :show, :new, :create] do
    get :execute
    get :cancel
    get :invoice_download
    get :thank_you
  end

  post 'subscription/save_customer_data' => 'subscriptions#save_customer_data'
  post 'subscription/reload' => 'subscriptions#reload', :as => 'subscription_reload'
  post 'subscriptions/plan_detail' => 'subscriptions#plan_detail'
  post 'subscriptions/ipn' => 'subscriptions#confirm', :as => 'subscription_confirm'
  # get 'subscription/:id/confirm' => 'subscriptions#confirm', :as => 'subscription_confirm'
  # get 'subscription/:id/cancel' => 'subscriptions#cancel', :as => 'subscription_cancel'
  # get 'subscription/:id/recap' => 'subscriptions#recap', :as => 'subscription_recap'

  devise_for :users, :controllers => {
    :registrations => :registrations
  }

  # if routing the root path, update for your controller
  root to: 'home#index'

	resources :downloads, only: [:new, :create]
#	get 'download/options'
#	get 'download/new'

  resources :contacts, only: [:new, :create]
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
