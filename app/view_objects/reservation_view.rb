class ReservationView < ViewObject

  # alias method allows use to rename view_object to a clear name without the initializer
  alias_method :reservation,      :root_model
  alias_method :reservation_url,  :root_model_url
  alias_method :reservation_path, :root_model_path

  # delegate to model for attributes needed
  delegate  :date, :host, to: :reservation

  # methods for attribuits
  def host_name
    host || ""
  end

  def time_slot_name
    time_slot.time_slot_name
  end

  def event_name
    event.event_name
  end

  def space_name
    space.space_name
  end

  def tenant_name
    tenant.tenant_name
  end

  def reservation_date
    # reservation.date
    # I18n.l(reservation.date)
    reservation.date.in_time_zone(space.time_zone)
    # Time.at(1364046539).in_time_zone("Eastern Time (US & Canada)").strftime("%m/%d/%y %I:%M %p")
  end

  def resevation_hours
    time_slot.time_slot_hours
  end

  # view_objects for relationships
  def tenant
    TenantView.new(event.tenant)
  end

  def event
    EventView.new(reservation.event)
  end

  def space
    SpaceView.new(reservation.space)
  end

  def time_slot
    TimeSlotView.new(reservation.time_slot)
  end

end
