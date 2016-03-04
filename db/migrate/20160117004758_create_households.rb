class CreateHouseholds < ActiveRecord::Migration
  def change
    create_table :households do |t|
      t.string :name
      t.string :email
      t.string :phone

      t.string :address_1
      t.string :address_2
      t.string :city
      t.string :state
      t.string :zipcode

      t.string :rsvp_code, null: false

      t.boolean :has_responded, default: false, null: false
      t.boolean :reception_only, default: true, null: false

      t.text :comments

      t.timestamps null: false
    end
  end
end
