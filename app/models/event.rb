class Event < ApplicationRecord

  belongs_to :category
  belongs_to :tenant

  has_many :reservations, inverse_of: :event, dependent: :destroy
  has_many :spaces, through: :reservations, source: :space
  # has_many :reserved_time_slots, through: :reservations, source: :time_slot
  # has_many :reserved_time_slots, through: :reservations, source: :time_slot

  validates :category,   presence: true
  validates :tenant,     presence: true
  validates :event_name, presence: true

end
