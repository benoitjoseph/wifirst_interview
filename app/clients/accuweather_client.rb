# frozen_string_literal: true

require 'net/http'

class AccuweatherClient
  class ApiError < StandardError; end

  ACCUWEATHER_URI = 'http://dataservice.accuweather.com'
  ACCUWEATHER_PORT = 80

  def initialize
    @base_uri = URI(ACCUWEATHER_URI)
  end

  def daily_forecasts(city, params: {})
    path = build_uri(
      "/forecasts/v1/daily/5day/#{city.accuweather_key}",
      default_params.merge(details: true, **params)
    )

    request = Net::HTTP::Get.new(path)

    send_request(request)
  end

  def autocomplete(query, params: {})
    path = build_uri(
      '/locations/v1/cities/autocomplete',
      default_params.merge(q: query, **params)
    )

    request = Net::HTTP::Get.new(path)

    send_request(request)
  end

  def location(key, params: {})
    path = build_uri(
      "/locations/v1/#{key}",
      default_params.merge(details: true, **params)
    )

    request = Net::HTTP::Get.new(path)

    send_request(request)
  end

  private

  def build_uri(path, query_params = {})
    uri = URI.join(@base_uri, path)
    uri.query = query_params.to_query
    uri.to_s
  end

  def default_params
    {
      apikey: ENV.fetch('ACCUWEATHER_API_KEY', nil),
      language: 'en-us'
    }
  end

  def send_request(request)
    response = Net::HTTP.start(@base_uri.host, @base_uri.port, use_ssl: @base_uri.scheme == 'https') do |http|
      http.request(request)
    end

    handle_response(response)
  end

  def handle_response(response)
    case response
    when Net::HTTPSuccess
      JSON.parse(response.body)
    else
      raise(ApiError, response.body)
    end
  end
end
