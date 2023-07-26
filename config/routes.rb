# frozen_string_literal: true

Rails.application.routes.draw do
  scope module: :auth do
    resources :registrations, only: %i[new create]
    resources :sessions,      only: %i[new create destroy]
  end

  scope module: :authenticated do
    resources :cities, param: :accuweather_key, only: %i[index show]
  end

  # Authentication URLs shortcuts
  get    'sign_up',  to: 'auth/registrations#new'
  post   'sign_up',  to: 'auth/registrations#create'
  get    'sign_in',  to: 'auth/sessions#new'
  post   'sign_in',  to: 'auth/sessions#create'
  delete 'sign_out', to: 'auth/sessions#destroy'

  root to: 'authenticated/cities#index'
end
