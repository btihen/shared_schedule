class Space < ApplicationRecord

  belongs_to :tenant

  has_many :space_time_slots, inverse_of: :space, dependent: :destroy
  has_many :allowed_time_slots, through: :space_time_slots, source: :time_slot

  has_many :event_space_reservations, inverse_of: :space, dependent: :destroy
  has_many :events, through: :event_space_reservations, source: :event
  has_many :reserved_time_slots, through: :event_space_reservations, source: :time_slot

  validates :tenant,      presence: true
  validates :space_name,  presence: true
  validates :time_zone,   presence: true,
                          inclusion: { in: ApplicationHelper::TIME_ZONES_IN }

  validate :validate_reserved_time_slots_alowed
  validate :vaidate_reserved_time_slots_not_overlapping

  def is_double_booking_ok?
    is_double_booking_ok
  end

  private

  def validate_reserved_time_slots_alowed
  end
  def vaidate_reserved_time_slots_not_overlapping
  end
end
