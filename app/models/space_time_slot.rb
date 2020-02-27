class SpaceTimeSlot < ApplicationRecord

  belongs_to :space
  belongs_to :time_slot

  validates  :space,     presence: true
  validates  :time_slot, presence: true

end
