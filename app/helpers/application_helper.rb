module ApplicationHelper

  USER_ROLES    = ['admin', 'manager', 'scheduler', 'host', 'member', 'retired']
  # TIME_ZONES = ActiveSupport::TimeZone.all.map { |tz| tz.tzinfo.name }.uniq
  TIME_ZONES    = ActiveSupport::TimeZone::MAPPING.values.uniq
  TIME_ZONES_IN = (ActiveSupport::TimeZone::MAPPING.keys +
                        ActiveSupport::TimeZone::MAPPING.values).uniq

end
