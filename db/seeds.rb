# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
error_msg = "DataSeeds not allowed in production"
raise StandarError, error_msg      if Rails.env.production?
raise StandarError, error_msg  unless Rails.env.development? || Rails.env.test?

# Everything belongs to tenant - delete tenant - takes all assosciated records too
Tenant.destroy_all

# figure out login for site-admin
# admin  = FactoryBot.create :user, tenant: tenant, user_role: "admin", email: "admin@example.ch",   password: "Let-M3-In!", password_confirmation:  "Let-M3-In!"
# users << admin

5.times do
  tenant  = FactoryBot.create :tenant

  FactoryBot.create :reason, tenant: tenant
  reasons = []
  5.times do
    reason   = FactoryBot.create :reason, tenant: tenant
    reasons << reason
  end

  users  = []
  5.times do
    user = FactoryBot.create :user, tenant: tenant, user_role: ApplicationHelper::USER_ROLES.sample, password: "Let-M3-In!", password_confirmation:  "Let-M3-In!"
    interests_count = rand(1..(reasons.length-1))
    user.interests  << reasons.sample(interests_count)
    user.save!
    users << user
  end
  tenant.save!

  breakfast = TimeSlot.create time_slot_name: "Frühstuck",  begin_time: "06:00", end_time: "10:00", tenant: tenant
  morning   = TimeSlot.create time_slot_name: "Morgen",     begin_time: "08:00", end_time: "12:00", tenant: tenant
  lunch     = TimeSlot.create time_slot_name: "Mittag",     begin_time: "10:00", end_time: "14:00", tenant: tenant
  afternoon = TimeSlot.create time_slot_name: "Nachmittag", begin_time: "13:00", end_time: "18:00", tenant: tenant
  dinner    = TimeSlot.create time_slot_name: "Abend-Essen",begin_time: "16:00", end_time: "20:00", tenant: tenant
  evening   = TimeSlot.create time_slot_name: "Abend",      begin_time: "18:00", end_time: "22:00", tenant: tenant

  spaces = []
  (1..rand(1..5)).each do |index|
    double_booking_bool = ((index % 2) == 0)
    space   = FactoryBot.create :space, tenant: tenant, is_double_booking_ok: double_booking_bool
    space.allowed_time_slots << [morning, afternoon, evening]
    space.allowed_time_slots << [breakfast, lunch, dinner]
    space.save
    spaces << space
  end

  (-2..2).each do |shift| 
    date_0  = Date.today + shift.weeks
    date_1  = date_0 + 1.day
    date_2  = date_0 + 2.days
    date_3  = date_0 + 3.days
    date_4  = date_0 + 4.days
    event = FactoryBot.create :event, reason: reasons.sample, tenant: tenant

    # schedule events within spaces
    spaces.each do |space|
      # make space reservation through event
      event.event_space_reservations << EventSpaceReservation.create(space: space, date: date_0, time_slot: afternoon)
      event.event_space_reservations << EventSpaceReservation.create(space: space, date: date_1, time_slot: evening)
      event.event_space_reservations << EventSpaceReservation.create(space: space, date: date_4, time_slot: evening)

      # make event reservation through space probably most common
      if space.is_double_booking_ok
        event.event_space_reservations << EventSpaceReservation.create(space: space, date: date_2, time_slot: morning)
        event.event_space_reservations << EventSpaceReservation.create(space: space, date: date_2, time_slot: afternoon)

        event.event_space_reservations << EventSpaceReservation.create(space: space, date: date_3,  time_slot: breakfast)
        event.event_space_reservations << EventSpaceReservation.create(space: space, date: date_3,  time_slot: lunch)
        event.event_space_reservations << EventSpaceReservation.create(space: space, date: date_3,  time_slot: dinner)
      end
      space.save
    end
  end

end
