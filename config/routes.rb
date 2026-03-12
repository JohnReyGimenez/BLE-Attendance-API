Rails.application.routes.draw do
  resource :session
  resources :passwords, param: :token

  get "signup", to: "registrations#new"
  post "signup", to: "registrations#create"

  root "classrooms#index"

  resources :classrooms, only: [ :index, :show, :new, :create ] do
    member do
      patch :archive
      post :assign_student
      delete :remove_student
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

  get "up" => "rails/health#show", as: :rails_health_check
end
