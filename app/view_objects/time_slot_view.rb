class TimeSlotView < ViewObject 

  # alias method allows use to rename view_object to a clear name without the initializer
  alias_method :time_slot,      :root_model
  alias_method :time_slot_url,  :root_model_url
  alias_method :time_slot_path, :root_model_path

  # delegate to model for attributes needed
  delegate  :time_slot_name, :begin_time, :end_time, to: :time_slot

  # convert begin and end times for comparison?

  def time_slot_name
    time_slot_name
  end

  # view_objects for relationships
  def tenant
    TenantView.new(time_slot.tenant)
  end

end
