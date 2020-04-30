class Tenant < ApplicationRecord

  has_many :events,       inverse_of: :tenant, dependent: :destroy
  has_many :spaces,       inverse_of: :tenant, dependent: :destroy
  has_many :categories,   inverse_of: :tenant, dependent: :destroy
  has_many :users,        inverse_of: :tenant, dependent: :destroy
  has_many :time_slots,   inverse_of: :tenant, dependent: :destroy
  has_many :reservations, inverse_of: :tenant, dependent: :destroy

  validates :tenant_name, presence: true

  # all public viewable and also own tenant if private
  # .where(is_demo_tenant: true).or(Tenant.where(is_publicly_viewable: true)).first || DemoTenant.new
  scope :landing_page, ->(user) { tenant = if user.guest?
                                              where(is_demo_tenant: true)
                                              .or(self.where(is_publicly_viewable: true))
                                              .first
                                            else
                                              where(id: user.tenant.id).first
                                            end
                                  tenant.blank? ? DemoTenant.new : tenant
                                }
  scope :viewable_by, ->(user)  { where(is_publicly_viewable: true)
                                  .or(self.where(id: user.tenant.id))
                                  .order(:id)
                                }

  def is_demo?
    is_demo_tenant && is_publicly_viewable
  end

  def is_publicly_viewable?
    is_publicly_viewable
  end

end
