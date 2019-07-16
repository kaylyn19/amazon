Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/', to: 'welcome#index', as:'root'
  get '/about', to: 'welcome#about'
  get '/contacts/new', to: 'contacts#new'
  post '/contacts', to:'contacts#thank_you'

  get '/products/new', {to: 'products#new', as: :new_product}
  post '/products', {to: 'products#create'}

  get '/products/:id', {to: 'products#show', as: :show_product}
  get '/products', {to: 'products#index', as: :index}

  delete '/products/:id', to: "products#destroy"

  get '/products/:id/edit', {to: "products#edit", as: :edit_product}
  patch '/products/:id', {to: 'products#update', as: :product}

  post '/products/:product_id/reviews', {to: "reviews#create", as: :product_reviews}
  delete '/products/:product_id/reviews/:id', {to: "reviews#destroy", as: :product_review}
  patch "/reviews/:id/toggle" => "reviews#toggle_hidden", as: "toggle_hidden"

  resources :users, only: [:new, :create]
  resource :sessions, only: [:new, :create, :destroy]

  post '/products/:product_id/reviews/:review_id/likes', {to: "likes#create", as: :product_review_likes}
  delete '/products/:product_id/reviews/:review_id/likes/:id', {to: "likes#destroy", as: :product_review_like}

  resources :products do
    resources :favourites, only: [:create, :destroy]
  end

  get '/admin/panel', to: 'administrators#panel'
  get '/favourites', to: 'welcome#favourite'

  resources :news_articles
end
