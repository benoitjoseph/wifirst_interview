# frozen_string_literal: true

module Cities
  module Fetch
    class FetchCity < Micro::Case
      attributes :accuweather_key

      def call!
        city = city_from_cache || city_from_accuweather

        Success(result: { city: city })
      rescue AccuweatherClient::ApiError => e
        Failure(:api_error, result: { error: e })
      end

      private

      def city_from_cache
        City.find_by(accuweather_key: accuweather_key)
      end

      def city_from_accuweather
        city_data = client.location(accuweather_key)

        City.find_or_create_from_accuweather(city_data)
      end

      def client
        @client ||= AccuweatherClient.new
      end
    end
  end
end
