# frozen_string_literal: true

module Cities
  module Fetch
    class Service < Micro::Case
      attributes :accuweather_key

      def call!
        call(FetchCity)
          .then(RefreshDailyForecasts)
      end
    end
  end
end
