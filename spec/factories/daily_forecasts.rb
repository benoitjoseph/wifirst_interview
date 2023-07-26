# frozen_string_literal: true

FactoryBot.define do
  factory :daily_forecast do
    city

    starts_at { Time.zone.now }
    ends_at   { 1.day.from_now }

    temperature_unit { 'C' }
    min_temperature  { 10.0 }
    max_temperature  { 20.0 }
  end
end
