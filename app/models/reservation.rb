class Reservation < ApplicationRecord

  belongs_to :event
  belongs_to :space
  belongs_to :end_time_slot,    class_name: 'TimeSlot', foreign_key: 'end_time_slot_id'
  belongs_to :start_time_slot,  class_name: 'TimeSlot', foreign_key: 'start_time_slot_id'

  validates :start_date,      presence: true
  validates :end_date,        presence: true
  validates :event,           presence: true
  validates :space,           presence: true
  validates :start_time_slot, presence: true
  validates :end_time_slot,   presence: true

end
