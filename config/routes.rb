Rails.application.routes.draw do
  get 'solutions/create'
  get 'solutions/show'
  get 'homeworks/index'
  get 'homeworks/show'
  get 'homeworks/new'
  get 'homeworks/create'
  resources :profiles, only: [:show, :edit, :update]
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users, skip: :registrations
  devise_for :students, only: :registrations
  devise_for :teachers, only: :registrations
  root 'home#index'

  resources :courses do
    resources :groups do
      resources :session_modifications, only: [:create]
      post 'enroll', on: :member
    end
  end
  
  resources :groups, only: [:index]
  # Since sessions are tied to groups, you might want to nest them as well
  resources :groups, only: [] do  # No need to re-define routes handled in the nested block above
    resources :sessions
  end

  resources :teachers, only: [:show] do
    collection do
      get 'search'
    end
  end
  
  get 'teachers/search', to: 'teachers#search'


  # Enrollments could be nested under groups or handled separately
  resources :groups, only: [] do  # This ensures we don't redefine the whole groups resource
    resources :enrollments, only: [:create, :destroy]
  end
  
  namespace :backend do
    resources :enrollments, only: [:index, :update]
  end

  resources :enrollments, only: [] do
    member do
      put :approve_by_teacher
      put :decline_by_teacher
    end
  end

  get 'pending_enrollments', to: 'teachers#pending_enrollments', as: 'teacher_pending_enrollments'

  get 'enrolled_groups', to: 'students#enrolled_groups', as: 'student_groups_enrolled'
  
  resources :courses do
    resources :groups do
      resources :rooms
      resources :homeworks do
        resources :solutions, only: [:create, :show]
        member do
          patch :provide_feedback
        end
      end
    end
  end

  resources :rooms, only: [:create, :destroy] do
    resources :messages, only: [:create]
  end
  
  resources :home do
    collection do
      get :join_now
      get :under_construction
    end
  end

  resources :dashboards do
    collection do
      get :sessions
    end
  end

  resources :events, only: [:index]
  get '/oauth2callback', to: 'google_auth#oauth2callback'

  #  get 'teacher/:id', to: 'teachers#show', as: 'teacher'
   get 'student/:id', to: 'students#show', as: 'student'

  mount ActionCable.server => '/cable'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
