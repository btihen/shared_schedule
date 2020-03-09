json.extract! reservation, :id, :tenant_name, :space_name, :event_name, :host_name,
                            :time_slot_name, :date, :begin_time, :end_time,
                            :reservation_date, :reservation_hours,
                            :created_at, :updated_at
json.url reservation_url(reservation, format: :json)
