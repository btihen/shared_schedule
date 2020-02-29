class TenantView < ViewObject 

  # alias method allows use to rename view_object to a clear name without the initializer
  alias_method :tenant,      :root_model
  alias_method :tenant_url,  :root_model_url
  alias_method :tenant_path, :root_model_path

  # delegate to model for attributes needed
  delegate  :tenant_name, :tenant_tagline, :tenant_site_url,
            :tenant_logo_url, :tenant_description to: :tenant

  # has_many :events,     inverse_of: :tenant, dependent: :destroy
  # has_many :spaces,     inverse_of: :tenant, dependent: :destroy
  # has_many :reasons,    inverse_of: :tenant, dependent: :destroy
  # has_many :users,      inverse_of: :tenant, dependent: :destroy
  # has_many :time_slots, inverse_of: :tenant, dependent: :destroy


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
