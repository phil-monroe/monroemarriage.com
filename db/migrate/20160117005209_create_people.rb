class CreatePeople < ActiveRecord::Migration
  def change
    create_table :people do |t|
      t.string  :first_name
      t.string  :last_name
      t.integer :household_id
      t.integer :position

      t.boolean :attending, null: false, default: false

      t.timestamps null: false
    end
  end
end
