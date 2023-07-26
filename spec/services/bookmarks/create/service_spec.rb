# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Bookmarks::Create::Service do
  let(:service) { described_class }
  let(:city) { create(:city) }
  let(:user) { create(:user) }
  let(:params) do
    { city: city, user: user }
  end

  describe '.call' do
    context 'without an existing bookmark' do
      it { expect(service.call(params)).to be_success }
      it { expect(service.call(params).data[:city]).to be_a(City) }
      it { expect { service.call(params) }.to change(Bookmark, :count).from(0).to(1) }
    end

    context 'with an existing bookmark' do
      before do
        create(:bookmark, city: city, user: user)
      end

      it { expect(service.call(params)).to be_success }
      it { expect(service.call(params).data[:city]).to be_a(City) }
      it { expect { service.call(params) }.not_to change(Bookmark, :count) }
    end
  end
end
