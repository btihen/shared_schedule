class TimeSlot < ApplicationRecord

  belongs_to :tenant

  # has_many :reservations,     dependent: :destroy
  has_many :start_times_reserved, dependent: :destroy, class_name: 'Reservation', foreign_key: 'start_time_slot_id'
  has_many :end_times_reserved,   dependent: :destroy, class_name: 'Reservation', foreign_key: 'end_time_slot_id'

  has_many :space_time_slots, dependent: :destroy

  validates :tenant,          presence: true
  validates :time_slot_name,  presence: true
  validates :begin_time,      presence: true
  validates :end_time,        presence: true

end
