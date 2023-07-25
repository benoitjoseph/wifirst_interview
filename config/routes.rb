# frozen_string_literal: true

Rails.application.routes.draw do
  scope module: :authenticated do
    resource :dashboard, only: [:show]
  end

  root to: 'authenticated/dashboards#show'
end
