module ApplicationHelper

  ADMIN_ROLES   = ['admin']
  USER_ROLES    = ['manager', 'scheduler', 'host', 'member', 'retired']
  # TIME_ZONES = ActiveSupport::TimeZone.all.map { |tz| tz.tzinfo.name }.uniq
  TIME_ZONES    = ActiveSupport::TimeZone::MAPPING.values.uniq
  TIME_ZONES_IN = (ActiveSupport::TimeZone::MAPPING.keys +
                        ActiveSupport::TimeZone::MAPPING.values).uniq
  def self.site_title
    tenants = Tenant.all
    return tenants.first.tenant_name  if tenants.count == 1

    'Shared Resources'
  end
end
