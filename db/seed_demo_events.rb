tenant     = Tenant.find_by(tenant_name: "DemoGroup")
reasons    = Reason.where(tenant_id: tenant.id)
spaces     = Space.where(tenant_id: tenant.id)

reasons.destroy_all # destroys events too

reasons = []
5.times do
  reason   = FactoryBot.create :reason, tenant: tenant
  reasons << reason
end

(-4..6).each do |shift|
  date_0  = Date.today + shift.weeks
  date_1  = date_0 + 1.day
  date_2  = date_0 + 2.days
  date_3  = date_0 + 3.days
  date_4  = date_0 + 4.days
  event = FactoryBot.create :event, reason: reasons.sample, tenant: tenant

  # schedule events within spaces
  spaces.each do |space|

    time_slots = space.allowed_time_slots

    event.event_space_reservations << EventSpaceReservation.create(space: space, date: date_0, time_slot: time_slots.sample)
    event.event_space_reservations << EventSpaceReservation.create(space: space, date: date_1, time_slot: time_slots.first)
    event.event_space_reservations << EventSpaceReservation.create(space: space, date: date_1, time_slot: time_slots.second)
    event.event_space_reservations << EventSpaceReservation.create(space: space, date: date_4, time_slot: time_slots.sample)
    event.save
  end
end
