# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Auth::RegistrationsController do
  let(:params) do
    {
      user: {
        name: 'John Doe',
        email: email,
        password: 'password'
      }
    }
  end
  let(:email) { 'valid@email.com' }
  let(:user) { create(:user, email: email) }

  describe '#new' do
    context 'when user is already signed-in' do
      before { sign_in(user) }

      it 'redirects to cities index' do
        get :new

        expect(response).to redirect_to(cities_path)
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
    context 'when user is already signed-in' do
      before { sign_in(user) }

      it 'redirects to cities index' do
        post :create

        expect(response).to redirect_to(cities_path)
      end
    end

    context 'with valid params' do
      it 'call the service & redirect' do
        expect(Registrations::Create::Service).to receive(:call).and_call_original

        post :create, params: params

        expect(response).to redirect_to(cities_path)
        expect(User.count).to eq(1)
      end
    end

    context 'with invalid params' do
      let(:email) { 'invalid_email' }

      it 'calls the service & does not create a user' do
        expect(Registrations::Create::Service).to receive(:call).and_call_original

        post :create, params: params

        expect(response).to have_http_status(:bad_request)
        expect(User.count).to eq(0)
      end
    end

    context 'when the email is already taken' do
      before { user }

      it 'calls the service & does not create a user' do
        expect(Registrations::Create::Service).to receive(:call).and_call_original

        post :create, params: params

        expect(response).to have_http_status(:bad_request)
        expect(User.count).to eq(1)
      end
    end
  end
end
