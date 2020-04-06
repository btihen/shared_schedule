class Tenant < ApplicationRecord

  has_many :events,       inverse_of: :tenant, dependent: :destroy
  has_many :spaces,       inverse_of: :tenant, dependent: :destroy
  has_many :reasons,      inverse_of: :tenant, dependent: :destroy
  has_many :users,        inverse_of: :tenant, dependent: :destroy
  has_many :time_slots,   inverse_of: :tenant, dependent: :destroy
  has_many :reservations, inverse_of: :tenant, dependent: :destroy

  validates :tenant_name, presence: true

  # all public viewable and also own tenant if private
  scope :viewable,  ->(user_tenant) { where(is_publicly_viewable: true)
                                      .or(Tenant.where(id: user_tenant.id))
                                      .order(:id)
                                    }

  def is_demo?
    is_demo_tenant && is_publicly_viewable
  end

  def is_publicly_viewable?
    is_publicly_viewable
  end

end
