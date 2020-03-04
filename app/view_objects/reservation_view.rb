class ReservationView < ViewObject

  # alias method allows use to rename view_object to a clear name without the initializer
  alias_method :reservation,      :root_model
  alias_method :reservation_url,  :root_model_url
  alias_method :reservation_path, :root_model_path

  # delegate to model for attributes needed
  delegate  :date, to: :reservation

  # methods for attribuits
  def host
    event.host || ""
  end

  # view_objects for relationships
  # def tenant
  #   TenantView.new(event.tenant)
  # end

  def event
    EventView.new(reservation.event)
  end

  def event_name
    event.event_name
  end

  # def space
  #   SpaceView.new(reservation.space)
  # end

  def time_slot
    TimeSlotView.new(reservation.time_slot)
  end

  def hours_reserved
    "#{time_slot.begin_time.strftime('%H:%M')-time_slot.end_time.strftime('%H:%M')}"
  end

end
