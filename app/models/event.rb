class Event < ApplicationRecord

  belongs_to :reason
  belongs_to :tenant

  has_many :event_space_reservations, inverse_of: :event, dependent: :destroy
  has_many :spaces, through: :event_space_reservations, source: :space
  has_many :reserved_time_slots, through: :event_space_reservations, source: :time_slot

  validates :reason,     presence: true
  validates :tenant,     presence: true
  validates :event_name, presence: true

end
