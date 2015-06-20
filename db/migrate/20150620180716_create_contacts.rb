class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.string :first_name
      t.string :last_name
      t.string :street_address
      t.string :zip_code
      t.string :city
      t.string :country_code
      t.string :email
      t.string :phone_number
      t.string :twitter
      t.string :avatar_url

      t.timestamps null: false
    end
  end
end
