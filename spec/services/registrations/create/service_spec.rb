# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Registrations::Create::Service do
  let(:service) { described_class }

  describe '.call' do
    context 'with valid user params' do
      let(:params) do
        {
          name: 'John Doe',
          email: 'mail@domain.com',
          password: 'password'
        }
      end

      it { expect(service.call(params)).to be_success }
      it { expect { service.call(params) }.to change(User, :count).from(0).to(1) }
    end

    context 'with invalid user params' do
      let(:params) do
        {
          name: 'John Doe',
          email: 'invalid_email',
          password: 'password'
        }
      end

      it { expect(service.call(params)).to be_failure }
      it { expect { service.call(params) }.not_to change(User, :count) }
    end
  end
end
