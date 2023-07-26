# frozen_string_literal: true

class City < ApplicationRecord
  has_many :daily_forecasts, dependent: :destroy
  has_many :bookmarks,       dependent: :destroy

  scope :bookmarked_by, ->(user) { includes(:bookmarks).where(bookmarks: { user: user }) }

  validates :name,                presence: true
  validates :country,             presence: true
  validates :administrative_area, presence: true
  validates :accuweather_key,     presence: true, uniqueness: true
  validates :name,                uniqueness: { scope: %i[country administrative_area] }

  class << self
    def new_from_accuweather(data)
      new(**extract_params_from_accuweather(data))
    end

    def find_or_create_from_accuweather(data)
      City.find_or_create_by(**extract_params_from_accuweather(data))
    end

    private

    def extract_params_from_accuweather(data)
      {
        accuweather_key: data['Key'],
        country: data['Country']['ID'],
        name: data['LocalizedName'],
        administrative_area: data['AdministrativeArea']['ID']
      }
    end
  end
end
