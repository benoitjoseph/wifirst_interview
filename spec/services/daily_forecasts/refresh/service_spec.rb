# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DailyForecasts::Refresh::Service do
  let(:service) { described_class }
  let(:city) { create(:city) }
  let(:params) do
    { city: city }
  end
  let(:now) { Time.zone.now }

  let(:mocked_response) do
    {
      'DailyForecasts' => [
        forecast_data(now),
        forecast_data(now + 1.day),
        forecast_data(now + 2.days),
        forecast_data(now + 3.days),
        forecast_data(now + 4.days)
      ]
    }
  end

  def forecast_data(date, min_temp: 23.0, max_temp: 30.0)
    {
      'Date' => date.iso8601,
      'Temperature' => {
        'Minimum' => { 'Value' => min_temp, 'Unit' => 'F' },
        'Maximum' => { 'Value' => max_temp, 'Unit' => 'F' }
      }
    }
  end

  def generate_5_forecasts(expires_at:)
    5.times.each do |i|
      create(:daily_forecast, city: city,
                              starts_at: now + i.days,
                              ends_at: now + (i + 1).days,
                              expires_at: expires_at)
    end
  end

  describe '.call' do
    before do
      allow_any_instance_of(AccuweatherClient).to receive(:daily_forecasts).and_return(mocked_response)
    end

    context 'without daily forecasts' do
      it { expect(service.call(params)).to be_success }
      it { expect { service.call(params) }.to change(DailyForecast, :count).from(0).to(5) }
    end

    context 'with expired daily forecasts' do
      let!(:city) { create(:city, :with_expired_forecasts) }

      it { expect(service.call(params)).to be_success }
      it { expect { service.call(params) }.to change(DailyForecast, :count).by(5) }
    end

    context 'with existing daily forecasts' do
      let!(:city) { create(:city, :with_valid_forecasts) }

      it { expect(service.call(params)).to be_success }
      it { expect { service.call(params) }.not_to change(DailyForecast, :count) }
    end

    context 'with an API error' do
      before do
        allow_any_instance_of(AccuweatherClient).to receive(:daily_forecasts).and_raise(AccuweatherClient::ApiError)
      end

      it { expect(service.call(params)).to be_failure }
    end
  end
end
