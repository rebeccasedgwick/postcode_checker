# frozen_string_literal: true

class CreateWhitelistedPostcodes < ActiveRecord::Migration[5.2]
  def change
    create_table :whitelisted_postcodes do |t|
      t.string :postcode, null: false, index: { unique: true }
      t.timestamps
    end
  end
end
