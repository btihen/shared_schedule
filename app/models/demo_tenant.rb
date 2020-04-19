class DemoTenant
  def id
    0
  end
  def tenant_name
    "Shared Schedules"
  end
  def tenant_tagline
    "Try it out!  Calendar reset every 24hrs."
  end
  def tenant_site_url
    "http://localhost:3000/"
  end
  def tenant_logo_url
    nil
  end
  def tenant_description
    "Where groups come to share their space and schedule and keep informed."
  end
  def is_publicly_viewable
    true
  end
  def is_demo_tenant
    true
  end
  def is_demo?
    true
  end
end