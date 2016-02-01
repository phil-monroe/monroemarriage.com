class Person < ActiveRecord::Base
  belongs_to :household

  scope :attending_reception, -> { where(attending: true) }
  scope :attending_wedding,   -> { joins(:household).where(attending: true, households: { reception_only: false})}

  def name
    [first_name, last_name].join(" ")
  end
end
