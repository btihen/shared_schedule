class Space < ApplicationRecord

  belongs_to :tenant

  has_many :space_time_slots, inverse_of: :space, dependent: :destroy
  has_many :allowed_time_slots, through: :space_time_slots, source: :time_slot

  has_many :reservations, inverse_of: :space, dependent: :destroy
  has_many :events, through: :reservations, source: :event
  has_many :reserved_time_slots, through: :reservations, source: :time_slot

  validates :tenant,      presence: true
  validates :space_name,  presence: true
  validates :time_zone,   presence: true,
                          inclusion: { in: ApplicationHelper::TIME_ZONES_IN }

  validate :validate_reserved_time_slots_alowed
  validate :vaidate_reserved_time_slots_not_overlapping

  scope :viewable_by, ->(user, tenant){ if tenant.users.include?(user)
                                          # if the user owns the tenant - show everything
                                          where(tenant_id: user.tenant.id)
                                        elsif tenant.is_demo?
                                          # show all calendars if demo
                                          where(tenant_id: user.tenant.id)
                                        elsif tenant.is_publicly_viewable?
                                          # show only tenants that are public and their public calendars
                                          where(tenant_id: tenant.id).where(is_calendar_public: true)
                                        else
                                          []
                                        end
                                      }

  def is_calendar_public?
    is_calendar_public
  end

  def is_double_booking_ok?
    is_double_booking_ok
  end

  private

  def validate_reserved_time_slots_alowed
  end
  def vaidate_reserved_time_slots_not_overlapping
  end
end
