# frozen_string_literal: true

class CreateDailyForecasts < ActiveRecord::Migration[7.0]
  def change
    create_table :daily_forecasts do |t|
      t.bigint :city_id, null: false

      t.column :starts_at,  :timestamptz, null: false
      t.column :ends_at,    :timestamptz, null: false
      t.column :expires_at, :timestamptz, null: false

      t.string :temperature_unit, null: false
      t.float  :min_temperature,  null: false
      t.float  :max_temperature,  null: false

      t.timestamps
    end

    add_index :daily_forecasts, :city_id
    add_index :daily_forecasts, :starts_at
    add_index :daily_forecasts, :ends_at
    add_index :daily_forecasts, :expires_at
    add_index :daily_forecasts, %i[city_id starts_at ends_at], unique: true
    add_foreign_key :daily_forecasts, :cities
  end
end
