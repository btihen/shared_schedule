class TimeSlot < ApplicationRecord

  belongs_to :tenant

  has_many :event_space_reservations, dependent: :destroy
  has_many :space_time_slots,         dependent: :destroy

  validates :tenant,          presence: true
  validates :time_slot_name,  presence: true
  validates :begin_time,      presence: true
  validates :end_time,        presence: true

end
