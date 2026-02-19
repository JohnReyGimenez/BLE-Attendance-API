Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  root "classrooms#index"

  resources :classrooms, only: [ :index, :show, :new, :create ] do
    member do
      patch :archive
      post :assign_student
    end
  end

  namespace :api do
    namespace :v1 do
      resources :students do
        member do
          put :assign_tag
          put :unassign_tag
        end
      end

      resources :tags
      resources :attendance_records
      resources :attendances, only: [ :index, :create, :update ]
    end
  end

  # Health check route (optional)
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
