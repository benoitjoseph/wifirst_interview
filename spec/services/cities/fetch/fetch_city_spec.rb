# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Cities::Fetch::FetchCity do
  let(:service) { described_class }
  let(:params) do
    { accuweather_key: '264443' }
  end

  describe '.call' do
    context 'with an existing cached city' do
      let!(:city) { create(:city, accuweather_key: '264443') }

      it { expect(service.call(params)).to be_success }
      it { expect(service.call(params).data[:city]).to eq(city) }
      it { expect { service.call(params) }.not_to change(City, :count) }
    end

    context 'without an existing cached city' do
      let(:mocked_response) do
        {
          'Key' => '264443',
          'LocalizedName' => 'Parang',
          'AdministrativeArea' => { 'ID' => 'MAG' },
          'Country' => { 'ID' => 'PH' }
        }
      end

      before do
        allow_any_instance_of(AccuweatherClient).to receive(:location).and_return(mocked_response)
      end

      it { expect(service.call(params)).to be_success }
      it { expect(service.call(params).data[:city]).to be_a(City) }
      it { expect { service.call(params) }.to change(City, :count).from(0).to(1) }
    end

    context 'with an API error' do
      before do
        allow_any_instance_of(AccuweatherClient).to receive(:location).and_raise(AccuweatherClient::ApiError)
      end

      it { expect(service.call(params)).to be_failure }
    end
  end
end
