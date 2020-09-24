class Managers::TenantView < ViewObject

  # alias method allows use to rename view_object to a clear name without the initializer
  alias_method :tenant,      :root_model
  alias_method :tenant_url,  :root_model_url
  alias_method :tenant_path, :root_model_path

  # delegate to model for attributes needed
  delegate  :tenant_name, :is_demo?, :is_publicly_viewable?, to: :tenant

  # def is_demo?
  #   tenant.is_demo?
  # end

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

  def next_event(date_time = Time.now)
    Managers::Reservation.tenant_next(tenant, date_time).first
  end

  def next_event_formated(date_time = Time.now)
    reservation = next_event(date_time)
    return "---"  if reservation.blank? || reservation.start_date_time.blank?

    reservation.start_date_time.strftime("%a %d %b %Y @ %H:%M")
  end

  # relationships
  def users
    @users   ||= Managers::UserView.collection(tenant.users)
  end

  def spaces
    @spaces  ||= Managers::SpaceView.collection(tenant.spaces)
  end

  def spaces_viewable_by(user)
    # only show spaces if not logged in
    # guest user only sees public, logged in sees public and private in own tenant
    spaces        = Space.viewable_by(user, tenant)
    @spaces     ||= Managers::SpaceView.collection(spaces)
  end

  def categories
    @categories ||= Managers::CategoryView.collection(tenant.categories)
  end

  def events
    @events     ||= Managers::EventView.collection(tenant.events)
  end

  def time_slots
    @time_slots ||= Managers::TimeSlotView.collection(tenant.events)
  end

end
