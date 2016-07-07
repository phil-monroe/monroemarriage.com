class AddDrinksAlcoholToPeople < ActiveRecord::Migration
  def change
    add_column :people, :drinks_alcohol, :boolean, default: true
  end
end
