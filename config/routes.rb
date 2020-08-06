Rails.application.routes.draw do
  root to: 'articles#index'
  get '/:locale' => 'articles#index'

  scope "(:locale)", locale: /en|mk/ do
    resources :articles do
      resources :comments
    end

    get 'users/signup', to: 'users#new'
    resources :users, except: :new

    get 'login', to: 'sessions#new'
    post 'login', to: 'sessions#create'
    delete 'logout', to: 'sessions#destroy'
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
