Rails.application.routes.draw do
  devise_for :users

  resources :videos do
    member do
      post 'like'
      post 'dislike'
    end
  end

  root to: "videos#index"
end
