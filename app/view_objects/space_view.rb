class SpaceView < ViewObject

  # alias method allows use to rename view_object to a clear name without the initializer
  alias_method :space,      :root_model
  alias_method :space_url,  :root_model_url
  alias_method :space_path, :root_model_path

  # delegate to model for attributes needed
  delegate  :space_name, :space_location, :time_zone, to: :space

  # convert / invoke time-zone?

  # view_objects for relationships
  def tenant
    TenantView.new(space.tenant)
  end

  def tenant_name
    tenant.tenant_name
  end

  def events
    EvenntView.collection(space.events)
  end

  def allowed_time_slots
    TimeSlotView.collection(space.allowed_time_slots)
  end

  def reserved_time_slots
    TimeSlotView.collection(space.reserved_time_slots)
  end
  alias_method :reservations, :reserved_time_slots

  def reservation_hosts
    hosts = space.reserved_time_slots.map{ |r| r.host.to_s }
  end

end
