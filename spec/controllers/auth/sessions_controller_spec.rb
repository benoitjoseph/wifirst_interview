# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Auth::SessionsController do
  let(:params) do
    {
      user: {
        email: email,
        password: 'password'
      }
    }
  end
  let(:email) { 'user@email.com' }
  let(:user) { create(:user, email: 'user@email.com') }

  describe '#new' do
    context 'when user is already signed-in' do
      before { sign_in(user) }

      it 'redirects to dashboard' do
        get :new

        expect(response).to redirect_to(dashboard_path)
      end
    end

    context 'when user is not signed-in' do
      it 'returns a valid response' do
        get :new

        expect(response).to be_successful
      end
    end
  end

  describe '#create' do
    before { user }

    context 'when user is already signed-in' do
      before { sign_in(user) }

      it 'redirects to dashboard' do
        post :create

        expect(response).to redirect_to(dashboard_path)
      end
    end

    context 'with valid params' do
      it 'call the service & redirect' do
        expect(Auth::Sessions::Create::Service).to receive(:call).and_call_original

        post :create, params: params

        expect(response).to redirect_to(dashboard_path)
      end
    end

    context 'with invalid params' do
      let(:email) { 'another@email.com' }

      it 'calls the service & render form' do
        expect(Auth::Sessions::Create::Service).to receive(:call).and_call_original

        post :create, params: params

        expect(response).to have_http_status(:bad_request)
      end
    end
  end

  describe '#destroy' do
    before { sign_in(user) }

    it 'redirects to sign-in' do
      delete :destroy

      expect(response).to redirect_to(sign_in_path)
    end
  end
end
