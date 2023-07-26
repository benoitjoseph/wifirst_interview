# frozen_string_literal: true

module DailyForecasts
  module Refresh
    class Service < Micro::Case
      MIN_DAILY_FORECASTS      = 5 # next 5 days
      FORECAST_EXPIRATION_TIME = 1.hour

      attributes :city

      def call!
        refresh_daily_forecasts if expired_city_forecasts?

        Success(result: { city: city })
      rescue AccuweatherClient::ApiError => e
        Failure(:api_error, result: { error: e })
      end

      private

      def refresh_daily_forecasts
        forecasts_data = client.daily_forecasts(city)
        forecasts_data['DailyForecasts'].each { |forecast_data| refresh_forecast(forecast_data) }
      end

      def expired_city_forecasts?
        forecasts = city.daily_forecasts.within_range(Time.zone.now, 5.days.from_now)
        forecasts.size < MIN_DAILY_FORECASTS
      end

      # rubocop:disable Metrics/MethodLength
      def refresh_forecast(forecast_data)
        starts_at = Time.zone.parse(forecast_data['Date']).in_time_zone('Europe/Paris')
        ends_at   = starts_at + 1.day

        min_temperature, max_temperature, unit = extract_temperature_data(forecast_data)

        forecast = DailyForecast.unscoped # fetch all forecasts, including expired ones
                                .find_or_initialize_by(city_id: city.id, starts_at: starts_at, ends_at: ends_at)
        forecast.update!(
          temperature_unit: unit,
          min_temperature: min_temperature,
          max_temperature: max_temperature,
          expires_at: FORECAST_EXPIRATION_TIME.from_now
        )
      end
      # rubocop:enable Metrics/MethodLength

      def extract_temperature_data(forecast_data)
        min_temperature = forecast_data['Temperature']['Minimum']['Value']
        max_temperature = forecast_data['Temperature']['Maximum']['Value']
        unit            = forecast_data['Temperature']['Minimum']['Unit'] # identical to Maximum

        [min_temperature, max_temperature, unit]
      end

      def client
        @client ||= AccuweatherClient.new
      end
    end
  end
end
