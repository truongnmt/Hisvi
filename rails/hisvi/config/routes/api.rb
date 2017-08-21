require "api_constraints"

namespace :api, defaults: {format: "json"} do
  devise_scope :user do
    post "sign_in", to: "sessions#create"
    post "sign_up", to: "registrations#create"
    delete "sign_out", to: "sessions#destroy"
  end

  scope module: :v1,
    constraints: ApiConstraints.new(version: 1, default: true) do
      resources :users, only: %i(index show update destroy)
      resources :stories
      post "like", to: "like#create"
      delete "dislike", to: "like#destroy"
    end
end
