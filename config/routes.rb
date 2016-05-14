Rails.application.routes.draw do
  root 'weapons#index'
  get  'weapons/index'
end
