# frozen_string_literal: true

# keep views simple - when an object is nil at least return "" in view
class GuestUser
  attr_reader :tenant

  def initialize
    demo_tenant = Tenant.find_by(is_demo_tenant: true, is_publicly_viewable: true)
    @tenant     = if demo_tenant.blank?
                    DemoTenant.new
                  else
                    demo_tenant
                  end
  end

  def id
    0
  end

  def to_s
    "Guest User"
  end

  def user_role
    "scheduler"
  end

  def guest?
    true
  end
  alias_method :is_guest?, :guest?

  def tenant_id
    @tenant_id ||= @tenant.id
  end

  # answer "" for all unexpected calls
  def method_missing(m, *args, &block)
    ""
  end

  # act like any duck
  def respond_to?(method_name, include_private = false)
    true
  end

end
