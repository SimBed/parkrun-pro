class AddAddressToVenue < ActiveRecord::Migration[8.1]
  def change
    add_column :venues, :address, :string
    add_column :venues, :postcode, :string
    add_column :venues, :closest_city, :string
    add_column :venues, :region, :string

    add_index :venues, :closest_city
    add_index :venues, :region
  end
end
