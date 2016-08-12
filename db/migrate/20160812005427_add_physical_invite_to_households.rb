class AddPhysicalInviteToHouseholds < ActiveRecord::Migration
  def change
    add_column :households, :physical_invite, :boolean, default: false
  end
end
