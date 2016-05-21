Rails.application.routes.draw do
  root 'weapons#index'

  get "/:type", to: 'weapons#index', as: :weapons
end
