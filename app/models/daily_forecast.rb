# frozen_string_literal: true

class DailyForecast < ApplicationRecord
  TEMPERATURE_UNITS = %w[C F].freeze

  belongs_to :city

  default_scope { where("expires_at >= ?", Time.zone.now) }

  scope :within_range, lambda { |starts_at, ends_at|
    where(<<-SQL.squish, starts_at, ends_at)
      TSTZRANGE(?, ?, '[)') && TSTZRANGE(starts_at, ends_at, '[)')
    SQL
  }

  validates :starts_at,        presence: true
  validates :ends_at,          presence: true
  validates :temperature_unit, presence: true, inclusion: { in: TEMPERATURE_UNITS }
  validates :min_temperature,  presence: true
  validates :max_temperature,  presence: true

  def expired?
    expires_at < Time.zone.now
  end
end
