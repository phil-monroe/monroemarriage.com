class AddLastLoggedInAtToHouseholds < ActiveRecord::Migration
  def change
    add_column :households, :logged_in_at, :datetime
  end
end
