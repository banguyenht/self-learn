Rails.application.routes.draw do
 devise_for :users, controllers: { registrations: 'users/registrations', sessions: 'users/sessions'}
 resource :user, only: [:edit] do
  collection do
    patch 'update_password'
  end
end


  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resource :products
  root to: 'products#index'
end
