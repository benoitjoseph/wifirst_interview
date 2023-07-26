# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DailyForecast do
  it 'has a valid factory' do
    expect(build(:daily_forecast)).to be_valid
  end

  def create_forecast(starts_at, ends_at)
    create(:daily_forecast, starts_at: starts_at, ends_at: ends_at, expires_at: 30.minutes.from_now)
  end

  describe 'scopes' do
    describe 'default_scope' do
      let(:expired_forecast) { create(:daily_forecast, expires_at: 2.minutes.ago) }
      let(:forecast)         { create(:daily_forecast, expires_at: 30.minutes.from_now) }

      before do
        expired_forecast
        forecast
      end

      it { expect(described_class.all).to eq([forecast]) }
    end

    describe 'within range' do
      let(:starts_at) { Time.zone.now }
      let(:ends_at)   { 1.day.from_now }

      #
      #              ┌────────────────────────┐   ┌────────────────────────┐
      #              │          before        │   │          after         │
      #              └────────────────────────┘   └────────────────────────┘
      # ┌────────────────────────┐   ┌────────────────────────┐   ┌────────────────────────┐
      # │        previous        │   │         during         │   │          next          │
      # └────────────────────────┘   └────────────────────────┘   └────────────────────────┘
      #                            │                            │
      #                         starts_at                     ends_at
      #
      let(:previous_forecast) { create_forecast(starts_at - 1.day,     starts_at - 5.minutes) }
      let(:before_forecast)   { create_forecast(starts_at - 12.hours,  starts_at + 12.hours) }
      let(:during_forecast)   { create_forecast(starts_at + 5.minutes, ends_at - 5.minutes) }
      let(:after_forecast)    { create_forecast(ends_at - 12.hours,    ends_at + 12.hours) }
      let(:next_forecast)     { create_forecast(ends_at + 5.minutes,   ends_at + 1.day) }

      let(:all_forecasts) { [previous_forecast, before_forecast, during_forecast, after_forecast, next_forecast] }
      let(:expected_forecasts) { [before_forecast, during_forecast, after_forecast] }

      before do
        all_forecasts
      end

      it 'filters the forecasts' do
        expect(described_class.within_range(starts_at, ends_at)).to match_array(expected_forecasts)
      end
    end
  end
end
