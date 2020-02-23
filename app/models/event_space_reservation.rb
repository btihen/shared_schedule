class EventSpaceReservation < ApplicationRecord

  belongs_to :event
  belongs_to :space
  belongs_to :time_slot

end
