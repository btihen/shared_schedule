class TenantView < ViewObject 

  # alias method allows use to rename view_object to a clear name without the initializer
  alias_method :tenant,      :root_model
  alias_method :tenant_url,  :root_model_url
  alias_method :tenant_path, :root_model_path

  # delegate to model for attributes needed
  delegate  :tenant_name, to: :tenant

  # relationships
  def events
    EventView.collection(tenant.events)
  end

  def managers
    UserView.collection(tenant.managers)
  end

  def spaces
    SpaceView.collection(tenant.spaces)
  end

  def reasons
    ReasonView.collection(tenant.reasons)
  end

  # needed for managing members?
  def users
    UserView.collection(tenant.users)
  end

end
