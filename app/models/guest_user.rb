# frozen_string_literal: true

# keep views simple - when an object is nil at least return "" in view
class GuestUser

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

  def tenant
    @tenant ||= Tenant.unscoped.landing_page(self)
  end

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
