class Event < ApplicationRecord

  belongs_to :reason
  belongs_to :tenant

  has_many :event_space_reservations, inverse_of: :event, dependent: :destroy
  has_many :spaces, through: :event_space_reservations, source: :space #, dependent: :destroy_all
  has_many :reserved_time_slots, through: :event_space_reservations, source: :time_slot #, dependent: :destroy_all

  validates :reason,       presence: true
  validates :tenant,      presence: true
  validates :event_title, presence: true

end
