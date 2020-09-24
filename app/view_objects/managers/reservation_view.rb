class Managers::ReservationView < ViewObject

  # alias method allows use to rename view_object to a clear name without the initializer
  alias_method :reservation,      :root_model

  # delegate to model for attributes needed
  delegate  :start_date_time, :start_date, :end_date, :host, :is_cancelled?, to: :reservation

  # can't use root_model aliases with nested urls, ie:
  # alias_method :reservation_url,  :root_model_url
  # alias_method :reservation_path, :root_model_path
  # so creating paths with url_helpers
  def reservation_path
    url_helpers.space_reservation_path(space_id: space.id, id: id)
  end

  def edit_reservation_path
    url_helpers.edit_space_reservation_path(space_id: space.id, id: id)
  end

  def reservation_url
    url_helpers.space_reservation_url(space_id: space.id, id: id)
  end

  # methods for attribuits
  def change_notice
    reservation.change_notice || ""
  end

  def host_name
    @host_name ||= host || ""
  end

  def event_name
    @event_name ||= event.event_name
  end

  def space_name
    @space_name ||= space.space_name
  end

  def tenant_name
    @tenant_name ||= tenant.tenant_name
  end

  # view_objects for relationships
  def tenant
    @tenant ||= Managers::TenantView.new(event.tenant)
  end

  def event
    @event ||= Managers::EventView.new(reservation.event)
  end

  def space
    @space ||= Managers::SpaceView.new(reservation.space)
  end

  def end_time_slot
    @end_time_slot ||= Managers::TimeSlotView.new(reservation.end_time_slot)
  end

  def start_time_slot
    @start_time_slot ||= Managers::TimeSlotView.new(reservation.start_time_slot)
  end

  def date_range_string
    @date_range_string ||=
      if is_event_one_time_slot?
        "#{start_date.strftime("%Y-%m-%d")} (#{start_time_slot.time_slot_hours})"
      elsif is_event_one_day?
        "#{start_date.strftime("%Y-%m-%d")} (#{start_time_slot.start_time} - #{end_time_slot.finish_time})"
      else
        "#{start_date.strftime("%Y-%m-%d")} (#{start_time_slot.start_time}) -- #{end_date.strftime("%Y-%m-%d")} (#{end_time_slot.finish_time})"
      end
  end

  def date_range
    @date_range ||= (start_date .. end_date)
  end

  def is_event_one_day?
    return true   if start_date == end_date
    false
  end

  def is_event_one_time_slot?
    return true   if is_event_one_day? && (start_time_slot == end_time_slot)
    false
  end

  def is_multi_day_event?
    return true   if (end_date - start_date).to_i > 0
    false
  end

  def is_range_start?(date)
    return true   if is_multi_day_event? && (date == start_date)
    false
  end

  def is_range_end?(date)
    return true   if is_multi_day_event? && (date == end_date)
    false
  end

  def start_time_slot_name
    @start_time_slot_name ||= start_time_slot.time_slot_name
  end

  def end_time_slot_name
    @end_time_slot_name ||= end_time_slot.time_slot_name
  end

  # def reservation_end_date
  #   # reservation.date
  #   # I18n.l(reservation.date)
  #   reservation.end_date.in_time_zone(space.time_zone)
  #   # Time.at(1364046539).in_time_zone("Eastern Time (US & Canada)").strftime("%m/%d/%y %I:%M %p")
  # end

  # def reservation_start_date
  #   # reservation.date
  #   # I18n.l(reservation.date)
  #   reservation.start_date.in_time_zone(space.time_zone)
  #   # Time.at(1364046539).in_time_zone("Eastern Time (US & Canada)").strftime("%m/%d/%y %I:%M %p")
  # end

  # def date_time_range
  #   if is_event_one_time_slot?
  #     build_date_time_range(start_date, start_time_slot.begin_time,
  #                           start_date, start_time_slot.end_time)
  #   elsif is_event_one_day?
  #     build_date_time_range(start_date, start_time_slot.begin_time,
  #                           start_date, end_time_slot.end_time)
  #   else
  #     build_date_time_range(start_date, start_time_slot.begin_time,
  #                           end_date,   end_time_slot.end_time)
  #   end
  # end

  # def build_date_time_range(start_date, start_time, end_date, end_time)
  #   (build_date_time(start_date, start_time)..build_date_time(end_date, end_time))
  # end

  # def build_date_time(date, time)
  #   DateTime.new(date.year, date.month, date.day, time.hour, time.min)
  # end

end
