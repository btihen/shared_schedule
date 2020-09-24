class Managers::TimeSlotView < ViewObject

  # alias method allows use to rename view_object to a clear name without the initializer
  alias_method :time_slot,      :root_model
  # only useful with non-nested routes
  # alias_method :time_slot_url,  :root_model_url
  # alias_method :time_slot_path, :root_model_path

  # delegate to model for attributes needed
  delegate  :time_slot_name, :begin_time, :end_time, to: :time_slot

  # convert begin and end times for comparison?
  def to_s
    "#{time_slot_name}: #{start_time}-#{finish_time}"
  end

  def time_slot_hours
    "#{start_time}-#{finish_time}"
  end

  def start_time
    "#{begin_time.strftime('%H:%M')}"
  end

  def finish_time
    "#{end_time.strftime('%H:%M')}"
  end

  # view_objects for relationships
  def tenant
    Managers::TenantView.new(time_slot.tenant)
  end

  private

  def format_time(time)
    time.strftime('%H:%M')
  end

end
