class CreateComparisons < ActiveRecord::Migration[7.0]
  def change
    create_table :comparisons do |t|
      t.bigint :user_id, null: false
      t.bigint :city_id, null: false

      t.timestamps
    end

    add_index :comparisons, %i[user_id city_id], unique: true
    add_foreign_key :comparisons, :users
    add_foreign_key :comparisons, :cities
  end
end
