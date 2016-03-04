ActiveRecord::Base.transaction do
  CSV.foreach('guest-list.csv', headers: true) do |row|
    household = Household.find_or_create_by(id: row['household_id'])

    person = household.people.build
    person.first_name = row['first_name']
    person.last_name  = row['last_name']
    person.position   = household.people.count + 1

    last_names = household.people.map(&:last_name).uniq

    if last_names.size == 1
      household.name = ["The", last_names.first, "Family"].join(" ")
    else
      household.name = household.people.map(&:name).to_sentence
    end

    household.save! && person.save!
  end
end