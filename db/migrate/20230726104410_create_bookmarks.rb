class CreateBookmarks < ActiveRecord::Migration[7.0]
  def change
    create_table :bookmarks do |t|
      t.bigint :user_id, null: false
      t.bigint :city_id, null: false

      t.timestamps
    end

    add_index :bookmarks, %i[user_id city_id], unique: true
    add_foreign_key :bookmarks, :users
    add_foreign_key :bookmarks, :cities
  end
end
