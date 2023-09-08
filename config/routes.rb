Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  post '/generate_maze', to: 'mazes#generate'
  post '/solve_maze', to: 'mazes#solve'

end
