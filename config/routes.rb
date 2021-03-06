Mentions2tasks::Application.routes.draw do

  get "page/index"

  post ':pm_tool/search/mentions' => 'mentions#posted_search',          :as => :search_streaming
  get  ':pm_tool/tasks/for/:screen_name/mentions' => 'mentions#search', :as => :start_streaming
  get  'twitter/streaming/stop'  => 'mentions#stop',                    :as => :stop_streaming

  get  'oauth/redbooth'          => 'oauth_redbooth#authenticate',      :as => :oauth_redbooth
  get  'oauth/redbooth/callback' => 'oauth_redbooth#auth_callback',     :as => :oauth_redbooth_callback

  get  'oauth/refresh/redbooth'          => 'oauth_redbooth#refresh' ,   :as => :oauth_redbook_refresh
  get  'oauth/refresh/redbooth/callback' => 'oauth_redbooth#refresh_callback', :as => :oauth_redbook_refresh_callback

  get  'oauth/twitter'           => 'oauth_twitter#authenticate',       :as => :oauth_twitter
  get  'oauth/twitter/callback'  => 'oauth_twitter#callback',           :as => :oauth_twitter_callback

  get  'about'                   => 'page#about',            :as => :about
  root :to => 'page#about'

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
