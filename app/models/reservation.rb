class Reservation < ApplicationRecord

  belongs_to :event
  belongs_to :space
  belongs_to :time_slot

  validates :date,      presence: true
  validates :event,     presence: true
  validates :space,     presence: true
  validates :time_slot, presence: true

end
