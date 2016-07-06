class AddSentAtTimestampsToHouseholds < ActiveRecord::Migration
  def change
    add_column :households, :save_the_date_email_sent_at, :datetime
    add_column :households, :save_the_date_paper_sent_at, :datetime
    add_column :households, :invite_email_sent_at, :datetime
    add_column :households, :invite_paper_sent_at, :datetime
  end
end
