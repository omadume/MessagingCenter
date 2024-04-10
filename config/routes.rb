Rails.application.routes.draw do
  root to: 'passengers#new_import'
  resources :passengers, :only => [:index, :show] do
    collection do
      post :import
      post :email
    end
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
end
