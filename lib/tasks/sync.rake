namespace :sync do
  task :mailchimp => :environment do
    Gibbon::Request.api_key = ENV.fetch('MAILCHIMP_API_KEY')
    list_id = ENV.fetch('MAILCHIMP_LIST_ID')
    mailchimp = Gibbon::Request.new

    households = Household.where("email <> ''").map do |household|
      email_id = Digest::MD5.hexdigest(household.email.downcase.strip)

      details = {
        email_address: household.email.downcase.strip,
        status:        "subscribed",
        merge_fields: {
          NAME:      household.name,
          RSVP_CODE: household.rsvp_code
        },
        interests: {
          #has responded
          '71e9b4495a': household.logged_in_at.present?,

          #reception_only
          '123757e747': household.reception_only,

          #attending
          '1ed3aa91e2': household.people.where(attending: true).exists?
        }
      }

      puts details
      mailchimp.lists(list_id).members(email_id).upsert(body: details)
    end
  end
end