# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Auth::Sessions::Create::Service do
  let(:service) { described_class }
  let(:user) { create(:user, email: 'email@domain.com', password: 'password') }

  before { user }

  describe '.call' do
    context 'with valid credentials' do
      let(:params) do
        {
          email: 'email@domain.com',
          password: 'password'
        }
      end

      it { expect(service.call(params)).to be_success }
    end

    context 'with invalid credentials' do
      let(:params) do
        {
          email: 'another_email@domain.com',
          password: 'password'
        }
      end

      it { expect(service.call(params)).to be_failure }
    end
  end
end
