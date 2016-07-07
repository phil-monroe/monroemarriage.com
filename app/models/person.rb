class Person < ActiveRecord::Base
  belongs_to :household

  scope :attending,           -> { where(attending: true) }
  scope :drinkers,            -> { where(drinks_alcohol: true) }
  scope :attending_reception, -> { attending }
  scope :attending_wedding,   -> { invited_to_wedding.attending }

  scope :invited_to_wedding, -> { joins(:household).where(households: { reception_only: false }) }

  def name
    [first_name, last_name].join(" ")
  end
end
