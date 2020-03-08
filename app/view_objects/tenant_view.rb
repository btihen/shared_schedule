class TenantView < ViewObject

  # alias method allows use to rename view_object to a clear name without the initializer
  alias_method :tenant,      :root_model
  alias_method :tenant_url,  :root_model_url
  alias_method :tenant_path, :root_model_path

  # delegate to model for attributes needed
  delegate  :tenant_name, to: :tenant

  def is_demo?
    tenant.tenant_name == "DemoGroup"
  end

  # attributes that allow nils
  def tenant_logo_url
    tenant.tenant_logo_url || "https://placeimg.com/80/80/arch/sepia"
  end
  def tenant_site_url
    tenant.tenant_site_url || ""
  end
  def tenant_tagline
    tenant.tenant_tagline  || ""
  end
  def tenant_description
    tenant.tenant_description || ""
  end

  # relationships
  def users
    UserView.collection(tenant.users)
  end

  def spaces
    SpaceView.collection(tenant.spaces)
  end

  def reasons
    ReasonView.collection(tenant.reasons)
  end

  def events
    EventView.collection(tenant.events)
  end

  def time_slots
    TimeSlotView.collection(tenant.events)
  end

end
