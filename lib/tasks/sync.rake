namespace :sync do
  task :mailchimp => :environment do
    Gibbon::Request.api_key = ENV.fetch('MAILCHIMP_API_KEY')
    list_id = ENV.fetch('MAILCHIMP_LIST_ID')
    mailchimp = Gibbon::Request.new

    households = Household.where("email <> ''").map do |household|
      email_id = Digest::MD5.hexdigest(household.email.downcase)

      details = {
        email_address: household.email,
        status:        "subscribed",
        merge_fields: {
          NAME:      household.name,
          RSVP_CODE: household.rsvp_code
        },
        interests: {
          #has responded
          '5007773727': household.logged_in_at.present?,

          #reception_only
          '04057248dd': household.reception_only,

          #attending
          '5a9dc7441e': household.people.where(attending: true).exists?
        }
      }

      puts details
      mailchimp.lists(list_id).members(email_id).upsert(body: details)
    end
  end
end