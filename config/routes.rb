Rails.application.routes.draw do
  get "/:type", to: 'weapons#index', as: :weapons
  get "/" => redirect("/auto_rifles")
end
