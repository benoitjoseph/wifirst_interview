# frozen_string_literal: true

class Api::CitiesController < ApiController
  def average_temperature
    result = Cities::ComputeAverageTemperature::Service.call(accuweather_keys: params[:accuweather_keys])

    if result.success?
      render json: { **result.slice(:min_avg, :max_avg, :unit) }
    else
      render json: { error: result.type }, status: :bad_request
    end
  end
end
