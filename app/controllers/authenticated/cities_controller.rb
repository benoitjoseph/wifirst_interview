# frozen_string_literal: true

class Authenticated::CitiesController < AuthenticatedController
  def index
    @favorite_cities = City.bookmarked_by(current_user)

    result = Cities::Search::Service.call(query: params[:query])

    if result.success?
      @cities = result[:cities]
    else
      render_cities_error(result.type)
    end
  end

  def show
    fetch_and_refresh_service = Micro::Cases.flow([Cities::Fetch::Service, DailyForecasts::Refresh::Service])
    result = fetch_and_refresh_service.call(accuweather_key: params[:accuweather_key])

    if result.success?
      @city = result[:city]
    else
      render_cities_error(result.type)
    end
  end

  private

  def render_cities_error(error)
    @cities = City.none

    render_service_error(error, action: :index)
  end
end
