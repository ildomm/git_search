Rails.application.routes.draw do
  root to: "git#index"

  get 'git/index'
  post 'git/search'
end
