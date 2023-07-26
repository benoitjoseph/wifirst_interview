# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::CitiesController do
  let(:user) { create(:user) }
  let(:city) { create(:city) }

  let(:headers) do
    { 'Authorization' => "Bearer #{user.access_token}" }
  end

  describe '#index' do
    before do
      request.headers['Authorization'] = "Bearer #{token}"
    end

    context 'when user is not signed-in' do
      let(:token) { 'invalid_token' }

      it 'returns unauthorized' do
        get :average_temperature

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when user is signed-in' do
      let(:token) { user.access_token }

      let(:average_temperature_service) { instance_double('Service') }

      context 'without errors' do
        let(:call_result) { instance_double(Micro::Case::Result, success?: true, type: nil) }

        before do
          allow(Cities::ComputeAverageTemperature::Service).to receive(:call).and_return(call_result)
          allow(call_result).to receive(:slice).and_return({ min_avg: 20, max_avg: 30, unit: 'C' })
        end

        it 'calls the service & return the data' do
          get :average_temperature

          expect(Cities::ComputeAverageTemperature::Service).to have_received(:call)
          expect(response).to be_successful
          expect(parsed_body.keys).to match_array(%w[min_avg max_avg unit])
        end
      end

      context 'with errors' do
        let(:call_result) { instance_double(Micro::Case::Result, success?: false, type: nil) }

        before do
          allow(Cities::ComputeAverageTemperature::Service).to receive(:call).and_return(call_result)
        end

        it 'calls the service & returns :unauthorized' do
          get :average_temperature

          expect(Cities::ComputeAverageTemperature::Service).to have_received(:call)
          expect(response).to have_http_status(:bad_request)
        end
      end
    end
  end
end
