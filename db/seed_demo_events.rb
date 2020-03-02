# tenant     = Tenant.find_by(tenant_name: "DemoGroup")

# # DEMO Tenant
# tenant.destroy
# tenant    = FactoryBot.create :tenant, tenant_name: "DemoGroup", tenant_description: "Data reset every 24hrs",
#                               tenant_tagline: "Try it out",      tenant_logo_url: "https://loremflickr.com/g/96/96/bern"

# breakfast = TimeSlot.create time_slot_name: "Breakfast", begin_time: "06:00", end_time: "10:00", tenant: tenant
# morning   = TimeSlot.create time_slot_name: "Morning",   begin_time: "08:00", end_time: "12:00", tenant: tenant
# lunch     = TimeSlot.create time_slot_name: "Lunch",     begin_time: "10:00", end_time: "14:00", tenant: tenant
# afternoon = TimeSlot.create time_slot_name: "Afternoon", begin_time: "13:00", end_time: "18:00", tenant: tenant
# dinner    = TimeSlot.create time_slot_name: "Dinner",    begin_time: "16:00", end_time: "20:00", tenant: tenant
# evening   = TimeSlot.create time_slot_name: "Evening",   begin_time: "18:00", end_time: "22:00", tenant: tenant

# spaces = []
# spaces << FactoryBot.create(:space, space_name: "Single Usage Room", tenant: tenant, is_calendar_public: true, is_double_booking_ok: false)
# spaces << FactoryBot.create(:space, space_name: "Multi-Usage Room",  tenant: tenant, is_calendar_public: true, is_double_booking_ok: true)

# spaces.each do |space|
#   space.allowed_time_slots << [morning, afternoon, evening]
#   space.allowed_time_slots << [breakfast, lunch, dinner]
#   space.save
# end

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
