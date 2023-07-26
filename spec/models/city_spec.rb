# frozen_string_literal: true

require 'rails_helper'

RSpec.describe City do
  it 'has a valid factory' do
    expect(build(:city)).to be_valid
  end
end
