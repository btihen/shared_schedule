event_space_reservations
class EventReservationView < ViewObject 

  # alias method allows use to rename view_object to a clear name without the initializer
  alias_method :event_reservation,      :root_model
  alias_method :event_reservation_url,  :root_model_url
  alias_method :event_reservation_path, :root_model_path

  # delegate to model for attributes needed
  delegate  :date, to: :event_reservation

  # methods for attribuits
  def host
    event.host || ""
  end

  # view_objects for relationships
  # def tenant
  #   TenantView.new(event.tenant)
  # end

  def event
    EventView.new(event_reservation.event)
  end

  def space
    SpaceView.new(event_reservation.space)
  end

  def time_slot
    TimeSlotView.new(event_reservation.time_slot)
  end

end