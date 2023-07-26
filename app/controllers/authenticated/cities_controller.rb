# frozen_string_literal: true

class Authenticated::CitiesController < AuthenticatedController
  def index
    Cities::Search::Service.call(query: params[:query])
                           .on_success { |result| @cities = result[:cities] }
                           .on_failure { |result| render_cities_error(result.type) }
  end

  def show
    Cities::Fetch::Service.call(accuweather_key: params[:accuweather_key])
                          .on_success { |result| @city = result[:city] }
                          .on_failure { |result| render_cities_error(result.type) }
  end

  private

  def render_cities_error(error)
    @cities = City.none

    render_service_error(error, action: :index)
  end
end
