json.extract! reservation, :id, :tenant_name, :space_name, :event_name, :host_name,
                            :start_date, :end_date, :begin_time, :end_time,
                            :time_slot_name, :created_at, :updated_at
json.url reservation_url(reservation, format: :json)
