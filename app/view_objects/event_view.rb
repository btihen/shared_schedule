class EventView < ViewObject 

  # alias method allows use to rename view_object to a clear name without the initializer
  alias_method :event,      :root_model
  alias_method :event_url,  :root_model_url
  alias_method :event_path, :root_model_path

  # delegate to model for attributes needed
  delegate  :event_title, to: :event

  def event_hosts
    event_reservations.map(&:host).uniq.join(', ')
  end

  def event_description
    event.event_description || ""
  end

  # view_objects for relationships
  def tenant
    TenantView.new(event.tenant)
  end

  def reason
    ReasonView.new(event.reason)
  end

  def spaces
    SpaceView.collection(event.spaces).uniq
  end

  def reserved_time_slots
    TimeSlotView.collection(event.reserved_time_slots)
  end

  def event_reservations
    EventReservation.collection(event.event_space_reservations)
  end

end