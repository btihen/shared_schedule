class Space < ApplicationRecord

  belongs_to :tenant

  has_many :space_time_slots, inverse_of: :space # , dependent: :destroy
  has_many :allowed_time_slots, through: :space_time_slots, source: :time_slot, dependent: :destroy

  has_many :event_space_reservations, inverse_of: :space #, dependent: :destroy
  has_many :events, through: :event_space_reservations, source: :event, dependent: :destroy
  has_many :reserved_time_slots, through: :event_space_reservations, source: :time_slot, dependent: :destroy

  validates :tenant,      presence: true
  validates :space_name,  presence: true
  validates :time_zone,   presence: true,
                          inclusion: { in: ApplicationHelper::TIME_ZONES_IN } #,
                                                      # message: "%{value} is not a valid time_zone" }
end
