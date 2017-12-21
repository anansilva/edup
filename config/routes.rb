Rails.application.routes.draw do
  devise_for :publishers, path: 'publishers', controllers: {sessions: 'publishers/sessions'}
  devise_for :students, path: 'students', controllers: {sessions: 'students/sessions'}
  root to: 'pages#home'

  resources :publishers do
    resources :courses, param: :slug, only: [:new, :create, :index] do
      resources :contents, only: [:new, :create]
    end
  end

 resources :students do
    resources :courses, param: :slug, only: [:index] do
      resources :contents, only: [:index]
    end
  end

  get '/publishers/:publisher_id/courses/:course_slug/contents/invite_student', to: 'contents#invite_student_new', as: :invite
  post '/publishers/:publisher_id/courses/:course_slug/contents/invite_student', to: 'contents#invite_student_create'
  get '/publishers/:publisher_id/courses/:course_slug', to:'contents#index', as: :course_content

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
