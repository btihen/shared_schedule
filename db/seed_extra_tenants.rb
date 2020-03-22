# Create Developer Experimental for other Tenants
module SeedExtraTenants

  def self.create
    4.times do |index|
      tenant  = FactoryBot.create :tenant, is_publicly_viewable: index.even?

      FactoryBot.create :reason, tenant: tenant
      reasons = []
      5.times do
        reason   = FactoryBot.create :reason, tenant: tenant
        reasons << reason
      end

      users  = []
      users << FactoryBot.create(:user, email: "manager#{index}@group#{index}.ch", tenant: tenant, user_role: 'manager', password: "Let-M3-In!", password_confirmation:  "Let-M3-In!")
      ApplicationHelper::USER_ROLES.each do |role|
        user = FactoryBot.create :user, tenant: tenant, user_role: role, password: "Let-M3-In!", password_confirmation:  "Let-M3-In!"
        interests_count = rand(1..(reasons.length-1))
        user.interests  << reasons.sample(interests_count)
        user.save!
        users << user
      end

      breakfast = TimeSlot.create time_slot_name: "Breakfast", begin_time: "06:00", end_time: "10:00", tenant: tenant
      morning   = TimeSlot.create time_slot_name: "Morning",   begin_time: "08:00", end_time: "12:00", tenant: tenant
      lunch     = TimeSlot.create time_slot_name: "Lunch",     begin_time: "10:00", end_time: "14:00", tenant: tenant
      afternoon = TimeSlot.create time_slot_name: "Afternoon", begin_time: "13:00", end_time: "18:00", tenant: tenant
      dinner    = TimeSlot.create time_slot_name: "Dinner",    begin_time: "16:00", end_time: "20:00", tenant: tenant
      evening   = TimeSlot.create time_slot_name: "Evening",   begin_time: "18:00", end_time: "22:00", tenant: tenant

      spaces = []
      (1..rand(1..5)).each do |index|
        is_even = index.even? # ((index % 2) == 0)
        space   = FactoryBot.create :space, tenant: tenant, is_calendar_public: is_even, is_double_booking_ok: is_even
        space.allowed_time_slots << [morning, afternoon, evening]
        space.allowed_time_slots << [breakfast, lunch, dinner]
        space.save
        spaces << space
      end

      (-2..2).each do |shift|
        date_0  = Date.today + (shift*3).weeks
        date_1  = date_0 + 1.day
        date_2  = date_0 + 2.days
        date_3  = date_0 + 3.days
        date_4  = date_0 + 4.days
        date_5  = date_0 + 5.days
        event = FactoryBot.create :event, reason: reasons.sample, tenant: tenant

        # schedule events within spaces
        spaces.each do |space|
          # make space reservation through event
          event.reservations << Reservation.create(space: space, start_date: date_0, start_time_slot: afternoon, end_date: date_2, end_time_slot: evening)
          event.reservations << Reservation.create(space: space, start_date: date_3, start_time_slot: morning, end_date: date_3, end_time_slot: morning)
          event.reservations << Reservation.create(space: space, start_date: date_3, start_time_slot: evening, end_date: date_3, end_time_slot: evening)
          event.reservations << Reservation.create(space: space, start_date: date_5, start_time_slot: evening, end_date: date_5, end_time_slot: evening)

          # make event reservation through space probably most common
          # if space.is_double_booking_ok
          #   event.reservations << Reservation.create(space: space, date: date_2, time_slot: morning)
          #   event.reservations << Reservation.create(space: space, date: date_2, time_slot: afternoon)

          #   event.reservations << Reservation.create(space: space, date: date_3,  time_slot: breakfast)
          #   event.reservations << Reservation.create(space: space, date: date_3,  time_slot: lunch)
          #   event.reservations << Reservation.create(space: space, date: date_3,  time_slot: dinner)
          # end
          event.save
        end
      end
    end
  end

end
