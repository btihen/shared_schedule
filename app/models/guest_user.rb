# frozen_string_literal: true

# keep views simple - when an object is nil at least return "" in view
class GuestUser

  def role
    "user"
  end

  def to_s
    "Guest User"
  end

  def guest?
    true
  end

  def tenant
    Tenant.find_by(tenant_name: 'DemoGroup')
  end

  # def tenant_id
  #   Tenant.find_by(tenant_name: 'DemoGroup').id
  # end

  # answer "" for all unexpected calls
  def method_missing(m, *args, &block)
    ""
  end

  # act like any duck
  def respond_to?(method_name, include_private = false)
    true
  end

end
