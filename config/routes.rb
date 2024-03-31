Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  # get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root 'static_pages#new'
  resources :static_pages, only: %i[new create]

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end

  require 'sidekiq/web'

  Rails.application.routes.draw do
    Sidekiq::Web.use(Rack::Auth::Basic) do |user_id, password|
      [user_id, password] == [ENV['SIDEKIQ_BASIC_ID'], ENV['SIDEKIQ_BASIC_PASSWORD']]
    end
    mount Sidekiq::Web, at: '/sidekiq'
  end

end
