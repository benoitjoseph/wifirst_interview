# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User do
  it 'has a valid factory' do
    expect(build(:user)).to be_valid
  end

  describe 'validations' do
    let(:user) { build(:user, **params) }

    describe 'email' do
      context 'with an invalid email' do
        let(:params) { { email: 'invalid' } }

        it { expect(user).to be_invalid }
      end

      context 'with a valid email' do
        let(:params) { { email: 'email@domain.com' } }

        it { expect(user).to be_valid }
      end
    end
  end
end
