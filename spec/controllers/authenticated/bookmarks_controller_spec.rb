# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Authenticated::BookmarksController do
  let(:user) { create(:user) }
  let(:city) { create(:city) }

  before { sign_in(user) }

  describe '#create' do
    let(:fetch_and_bookmark_service) { instance_double('Service') }

    before do
      allow(Micro::Cases).to receive(:flow).with([Cities::Fetch::Service, Bookmarks::Create::Service])
                                           .and_return(fetch_and_bookmark_service)
      allow(fetch_and_bookmark_service).to receive(:call).and_return(call_result)
      allow(call_result).to receive(:[])
    end

    context 'without errors' do
      let(:call_result) { instance_double(Micro::Case::Result, success?: true, type: nil) }

      it 'calls the service' do
        post :create, params: { city_accuweather_key: city.accuweather_key }, format: :turbo_stream

        expect(Micro::Cases).to have_received(:flow).with([Cities::Fetch::Service, Bookmarks::Create::Service])
        expect(fetch_and_bookmark_service).to have_received(:call).with(accuweather_key: city.accuweather_key, user: user)
        expect(response).to be_successful
      end
    end

    context 'with errors' do
      let(:call_result) { instance_double(Micro::Case::Result, success?: false, type: :api_error) }

      it 'calls the service' do
        post :create, params: { city_accuweather_key: city.accuweather_key }, format: :turbo_stream

        expect(Micro::Cases).to have_received(:flow).with([Cities::Fetch::Service, Bookmarks::Create::Service])
        expect(fetch_and_bookmark_service).to have_received(:call).with(accuweather_key: city.accuweather_key, user: user)
        expect(response).to be_successful
      end

      it 'sets the flashes' do
        post :create, params: { city_accuweather_key: city.accuweather_key }, format: :turbo_stream

        expect(html_element('turbo-stream').to_s).to match(/flashes/)
      end
    end
  end

  describe '#destroy' do
    let!(:bookmark) { create(:bookmark, user: user, city: city) }
    let(:params) do
      { id: bookmark.id, city_accuweather_key: city.accuweather_key }
    end

    it 'deletes the bookmark and responds with turbo stream' do
      expect { delete :destroy, params: params, format: :turbo_stream }.to change(Bookmark, :count).by(-1)

      expect(response.content_type).to match(/turbo-stream/)
    end
  end
end
