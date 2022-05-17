Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  namespace :api do
    namespace :v1 do
      resources :tags
      resources :topics
      get '/topics(/:url)', to: 'topics#show', constraints: { url: /.+/ }
    end
  end
end
