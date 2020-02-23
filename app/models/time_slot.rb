class TimeSlot < ApplicationRecord

  belongs_to :tenant

  validates :tenant,     presence: true
  validates :time_slot_name,  presence: true

  validates :begin_time, presence: true #, format: { with: /\A([01]?[0-9]|2[0-3]):[0-5][0-9]\z/,
  #                                                  message: "must be in 24h format HH:MM" }
  validates :end_time,   presence: true #, format: { with: /\A(2[0-3]|[01][0-9]):([0-5][0-9])\z/,
  #                                                  message: "must be in 24h format HH:MM" }
  validate :validate_begin_n_end_time

  private

  def validate_begin_n_end_time
    # is an hour - 24h format
    # begin_time < end_time
  end

end
