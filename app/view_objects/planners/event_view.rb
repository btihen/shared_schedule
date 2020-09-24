class Planners::EventView < ViewObject

  # alias method allows use to rename view_object to a clear name without the initializer
  alias_method :event,      :root_model
  # alias_method :event_url,  :root_model_url
  # alias_method :event_path, :root_model_path

  # delegate to model for attributes needed
  delegate  :event_name, to: :event

  def event_hosts
    event_reservations.map(&:host).uniq.join(', ')
  end

  def event_description
    event.event_description || ""
  end

  # view_objects for relationships
  def tenant
    @tenant   ||= Planners::TenantView.new(event.tenant)
  end

  def category
    @category ||= Planners::CategoryView.new(event.category)
  end

  def spaces
    @spaces   ||= Planners::SpaceView.collection(event.spaces).uniq
  end

  def reserved_time_slots
    @reserved_time_slots ||= Planners::TimeSlotView.collection(event.reserved_time_slots)
  end

  def event_reservations
    @event_reservations ||= Planners::EventReservation.collection(event.reservations)
  end

end
