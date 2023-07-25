# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "#{n}-#{Faker::Internet.email}" }

    name     { Faker::Name.name }
    password { 'password' }
  end
end
