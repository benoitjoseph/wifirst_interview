# frozen_string_literal: true

module Cities
  module Search
    class Service < Micro::Case
      attributes :query

      def call!
        return Success(result: { cities: City.none }) if query.blank?

        cities = search_accuweather_cities

        Success(result: { cities: cities })
      rescue AccuweatherClient::ApiError => e
        Failure(:api_error, result: { error: e })
      end

      private

      def search_accuweather_cities
        cities_data = client.autocomplete(query)
        cities_data.map do |city_data|
          City.new_from_accuweather(city_data)
        end
      end

      def client
        @client ||= AccuweatherClient.new
      end
    end
  end
end
