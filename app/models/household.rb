class Household < ActiveRecord::Base
  has_many :people, -> { order('position') }
  accepts_nested_attributes_for :people

  scope :reception_only, ->{ where(reception_only: true) }
  scope :with_attendees, ->{ distinct.joins(:people).where(people: { attending: true } ) }

  after_initialize do
    self.rsvp_code ||= SecureRandom.hex(3)
  end

  def people_attributes= attrs
    self.people = attrs.map do |idx, person_attrs|
      puts person_attrs.to_json
      person = person_attrs[:id].present? ? Person.find(person_attrs[:id]) : Person.new
      if person_attrs[:_destroy] == "1"
        person.destroy
        nil

      else
        person.assign_attributes  person_attrs.slice(:first_name, :last_name, :position)
        person.save
        person
      end
    end.compact
  end
end
