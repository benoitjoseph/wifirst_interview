# frozen_string_literal: true

class Bookmark < ApplicationRecord
  belongs_to :user
  belongs_to :city

  validates :user_id, uniqueness: { scope: :city_id }
end
