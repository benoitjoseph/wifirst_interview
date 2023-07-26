# frozen_string_literal: true

class CreateCities < ActiveRecord::Migration[7.0]
  def change
    create_table :cities do |t|
      t.string :name,                null: false
      t.string :accuweather_key,     null: false
      t.string :country,             null: false
      t.string :administrative_area, null: false

      t.timestamps
    end

    add_index :cities, :name
    add_index :cities, :country
    add_index :cities, :administrative_area
    add_index :cities, %i[name country administrative_area], unique: true
    add_index :cities, :accuweather_key, unique: true
  end
end
