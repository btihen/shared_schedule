class EventSpaceReservationView < ViewObject

  # alias method allows use to rename view_object to a clear name without the initializer
  alias_method :event_space_reservation,      :root_model
  alias_method :event_space_reservation_url,  :root_model_url
  alias_method :event_space_reservation_path, :root_model_path

  # delegate to model for attributes needed
  delegate  :date, to: :event_space_reservation

  # methods for attribuits
  def host
    event.host || ""
  end

  # view_objects for relationships
  # def tenant
  #   TenantView.new(event.tenant)
  # end

  def event
    EventView.new(event_space_reservation.event)
  end

  def event_name
    event.event_name
  end

  # def space
  #   SpaceView.new(event_space_reservation.space)
  # end

  def time_slot
    TimeSlotView.new(event_space_reservation.time_slot)
  end

  def hours_reserved
    "#{time_slot.begin_time.strftime('%H:%M')-time_slot.end_time.strftime('%H:%M')}"
  end

end
