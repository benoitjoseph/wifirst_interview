# frozen_string_literal: true

FactoryBot.define do
  factory :city do
    sequence(:accuweather_key) { |n| "#{n}-accuweather_key" }
    sequence(:name)            { |n| "#{n}-#{Faker::Address.city}" }
    country                    { Faker::Address.country_code }
    administrative_area        { Faker::Address.state_abbr }

    # Can't use create_list because we need consecutive days
    # Tiny logic duplication but I couldn't figure where to define a
    # method accessible from the FactoryBot hooks
    trait :with_expired_forecasts do
      after(:create) do |city|
        now = Time.zone.now

        5.times.each do |i|
          create(:daily_forecast, city: city,
                                  starts_at: now + i.days,
                                  ends_at: now + (i + 1).days,
                                  expires_at: 30.minutes.ago)
        end
      end
    end

    trait :with_valid_forecasts do
      after(:create) do |city|
        now = Time.zone.now

        5.times.each do |i|
          create(:daily_forecast, city: city,
                                  starts_at: now + i.days,
                                  ends_at: now + (i + 1).days,
                                  expires_at: 30.minutes.from_now)
        end
      end
    end
  end
end
