# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Authenticated::CitiesController do
  let(:user) { create(:user) }
  let(:city) { create(:city) }

  before { sign_in(user) }

  describe '#show' do
    let(:fetch_and_refresh_service) { instance_double('Service') }

    before do
      allow(Micro::Cases).to receive(:flow).and_return(fetch_and_refresh_service)
      allow(fetch_and_refresh_service).to receive(:call).and_return(call_result)
      allow(call_result).to receive(:[])
    end

    context 'without errors' do
      let(:call_result) { instance_double(Micro::Case::Result, success?: true, type: nil) }

      it 'calls the service and responds successfully' do
        get :show, params: { accuweather_key: city.accuweather_key }

        expect(Micro::Cases).to have_received(:flow).with([Cities::Fetch::Service, DailyForecasts::Refresh::Service])
        expect(fetch_and_refresh_service).to have_received(:call).with(accuweather_key: city.accuweather_key)

        expect(response).to be_successful
      end
    end

    context 'with errors' do
      let(:call_result) { instance_double(Micro::Case::Result, success?: false, type: :api_error) }

      it 'calls the service and responds with bad_request' do
        get :show, params: { accuweather_key: city.accuweather_key }

        expect(Micro::Cases).to have_received(:flow).with([Cities::Fetch::Service, DailyForecasts::Refresh::Service])
        expect(fetch_and_refresh_service).to have_received(:call).with(accuweather_key: city.accuweather_key)

        expect(response).to have_http_status(:bad_request)
      end
    end
  end

  describe '#index' do
    before do
      allow(Cities::Search::Service).to receive(:call).and_return(call_result)
      allow(call_result).to receive(:[])
    end

    context 'without errors' do
      let(:call_result) { instance_double(Micro::Case::Result, success?: true, type: nil) }

      it 'calls the service and responds successfully' do
        get :index, params: { query: 'query' }

        expect(Cities::Search::Service).to have_received(:call).with(query: 'query')
        expect(response).to be_successful
      end
    end

    context 'with errors' do
      let(:call_result) { instance_double(Micro::Case::Result, success?: false, type: :my_error) }

      it 'calls the service and responds with bad_request' do
        get :index, params: { query: 'query' }

        expect(Cities::Search::Service).to have_received(:call).with(query: 'query')
        expect(response).to have_http_status(:bad_request)
      end
    end
  end
end
