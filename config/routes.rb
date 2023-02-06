Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  default_url_options :host => "http://localhost:3000/"
  get '/s/:slug', to: 'links#show', as: :short


  resources :links do 
    collection do
      get :expire_key
      get :increase_key
      get :data_link
      get :increase_visit
      get :import_clicked
    end
  end


  resources :shorts, only: [:show]




  root 'links#index'
end
