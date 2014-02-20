SeniorDesign::Application.routes.draw do
  
  match "groups/:id/show"                               => "groups#show", :via => :get
  match "organizations/:id/view_groups"                 => "organizations#view_groups", :via => :get
  match "organizations/:id/create_group"                => "organizations#create_group", :via => [:get, :post]
  match "organizations/:id/view_organization_charges"   =>   "organizations#view_organization_charges", :via => [:get, :post]
  match "organizations/:id/view_organization_members"   =>  "organizations#view_organization_members", :via => [:get, :post]
  match "organizations/:id/admin_view_org_member"       =>  "organizations#admin_view_org_member", :via => [:get, :post]
  match "organizations/join"                            => "organizations#join", :via => [:get, :post]
  match "organizations/:id/edit_admins"                 => "organizations#edit_admins", :via => [:get, :post]
  match "organizations/:id/create_charge"               => "organizations#create_charge", :via => [:get, :post]
  match "organizations/:id/make_payment"                => "organizations#create_payment", :via => [:get, :post]
  match "organizations/:id/pending_payments"            => "organizations#pending_payments", :via => [:get, :post]
  match "groups/:id/edit"                               => "groups#edit", :via => [:get, :post]
  resources :organizations
  
  root 'welcome#index'
  
  devise_for :users
  
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  get "dashboard" => "welcome#dashboard"

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
