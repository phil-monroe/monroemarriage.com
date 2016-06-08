class Household < ActiveRecord::Base
  has_many :people, -> { order('position') }
  accepts_nested_attributes_for :people

  scope :wedding,        ->{ where(reception_only: false) }
  scope :reception_only, ->{ where(reception_only: true) }
  scope :with_attendees, ->{ distinct.joins(:people).where(people: { attending: true } ) }

  scope :have_responded, ->{ where.not(logged_in_at: nil) }
  scope :have_not_responded, ->{ where(logged_in_at: nil) }

  scope :need_to_contact, -> { have_not_responded.where(email: nil) }

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
