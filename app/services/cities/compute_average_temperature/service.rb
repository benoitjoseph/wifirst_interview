# frozen_string_literal: true

module Cities
  module ComputeAverageTemperature
    class InterruptError < StandardError; end

    class Service < Micro::Case
      DEFAULT_TEMPERATURE_UNIT = '-'

      attributes :accuweather_keys, :datetime

      def call!
        daily_forecasts = find_and_refresh_cities.flat_map(&:daily_forecasts)

        min_avg, max_avg, unit = compute_average_temperature(daily_forecasts)

        Success result: { min_avg: min_avg, max_avg: max_avg, unit: unit }
      rescue InterruptError => e
        Failure :api_error, result: { error: e }
      end

      private

      def find_and_refresh_cities
        accuweather_keys.map { |accuweather_key| fetch_and_refresh_city(accuweather_key) }
      end

      def fetch_and_refresh_city(accuweather_key)
        result = Micro::Cases.flow([Cities::Fetch::Service, DailyForecasts::Refresh::Service])
                             .call(accuweather_key: accuweather_key)

        raise InterruptError unless result.success?

        result[:city]
      end

      def compute_average_temperature(daily_forecasts)
        return [0, 0, DEFAULT_TEMPERATURE_UNIT] if daily_forecasts.empty?

        min_avg = daily_forecasts.sum(&:min_temperature) / daily_forecasts.size
        max_avg = daily_forecasts.sum(&:max_temperature) / daily_forecasts.size

        unit = daily_forecasts.first.temperature_unit

        [min_avg.round(2), max_avg.round(2), unit]
      end
    end
  end
end
