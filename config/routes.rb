Rails.application.routes.draw do
  devise_for :students, controllers: {
    registrations: 'students/registrations'
  }
  devise_for :teachers

  resources :students, only: [:new, :create, :show]
  resources :assessment_items, only: [:new, :create, :index]

  root "trees#index"

  resources :teachers do
    get 'new_student'
    post 'create_student'
    post 'mark_assessment', to: 'marking#mark_assessment'
    post 'update_class_id', on: :collection
    member do
      get 'show_students'
      get 'edit_students'
    end

  end



  resources :marking do
    collection do
      get 'index'
    end
  end



  resources :trees do
    member do
      get :clone
      post :create_cloned_tree
    end


    post 'assign_student', on: :member, to: 'trees#assign_tree_to_student'
    member do
      delete 'remove_from_student'
    end
    post :share, on: :member
    delete :unshare, on: :member
    member do
      get 'student_view', to: 'marking#student_view'
    end
    member do
      post :update_cutoffs
    end
    get 'marking', to: 'marking#index'
    get '/marking/student_view', to: 'marking#student_view', as: 'student_view'
    post 'marking/save_branch_blossom_stages', to: 'marking#save_branch_blossom_stages'
    resources :assessment_items, only: [:new, :create, :show, :destroy]
    resources :branches do
      resources :blossoms do
        collection do
          patch :update_positions
        end
        resources :resources
      end
    end
    resources :session_goals
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
