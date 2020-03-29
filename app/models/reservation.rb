class Reservation < ApplicationRecord

  belongs_to :event
  belongs_to :space
  belongs_to :tenant
  belongs_to :end_time_slot,    class_name: 'TimeSlot', foreign_key: 'end_time_slot_id'
  belongs_to :start_time_slot,  -> { order 'time_slots.begin_time' },
                                class_name: 'TimeSlot', foreign_key: 'start_time_slot_id'

  validates :start_date,      presence: true
  validates :end_date,        presence: true
  validates :event,           presence: true
  validates :space,           presence: true
  validates :tenant,          presence: true
  validates :start_time_slot, presence: true
  validates :end_time_slot,   presence: true
  validates :start_date_time, presence: true

  scope :in_date_range, ->(date_range) {
                          where("start_date >= ?", date_range.first)
                          .where("end_date <= ?", date_range.last)
                        }
  scope :space_next,  ->(space_ids, date_time) {
                          where(space_id: space_ids)
                          .where("start_date_time > ?", date_time)
                          .limit(1)
                        }
  scope :tenant_next, ->(tenant, date_time) {
                          where(tenant_id: tenant.id)
                          .where("start_date_time > ?", date_time)
                          .limit(1)
                        }


end
