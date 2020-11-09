Rails.application.routes.draw do
  root to: 'videos#index'
  get '/videos' , to:'videos#index', :as => :videos
  get '/videos/:id', to: 'videos#play', :as => :video_play
  devise_for :users, skip: [:sessions]

  as :user do
    get 'signin', to:'devise/sessions#new', :as => :new_user_session
    post 'signin', to:'devise/sessions#create', :as => :user_session
    delete 'signout', to:'devise/sessions#destroy', :as => :destroy_user_session
  end

end

