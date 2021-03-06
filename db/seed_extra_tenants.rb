# Create Developer Experimental for other Tenants
module SeedExtraTenants

  def self.create
    4.times do |index|
      tenant  = FactoryBot.create :tenant, is_publicly_viewable: index.even?

      # FactoryBot.create :category, tenant: tenant
      categories = []
      3.times do
        category   = FactoryBot.create :category, tenant: tenant
        categories << category
      end

      events = []
      5.times do
        event   = FactoryBot.create :event, category: categories.sample, tenant: tenant
        events << event
      end

      users  = []
      users << FactoryBot.create(:user, email: "manager#{index}@group#{index}.ch", tenant: tenant, user_role: 'manager', password: "Let-M3-In!", password_confirmation:  "Let-M3-In!")
      ApplicationHelper::USER_ROLES.each do |role|
        user = FactoryBot.create :user, tenant: tenant, user_role: role, password: "Let-M3-In!", password_confirmation:  "Let-M3-In!"
        interests_count = rand(1..(categories.length-1))
        user.interests  << categories.sample(interests_count)
        user.save!
        users << user
      end

      breakfast = TimeSlot.create time_slot_name: "Breakfast", begin_time: "06:00", end_time: "10:00", tenant: tenant
      morning   = TimeSlot.create time_slot_name: "Morning",   begin_time: "08:00", end_time: "12:00", tenant: tenant
      brunch    = TimeSlot.create time_slot_name: "Brunch",    begin_time: "09:00", end_time: "15:00", tenant: tenant
      lunch     = TimeSlot.create time_slot_name: "Lunch",     begin_time: "11:00", end_time: "14:00", tenant: tenant
      afternoon = TimeSlot.create time_slot_name: "Afternoon", begin_time: "13:00", end_time: "18:00", tenant: tenant
      dinner    = TimeSlot.create time_slot_name: "Dinner",    begin_time: "16:00", end_time: "20:00", tenant: tenant
      evening   = TimeSlot.create time_slot_name: "Evening",   begin_time: "18:00", end_time: "22:00", tenant: tenant

      spaces = []
      (0..rand(1..5)).each do |idx|
        space   = FactoryBot.create :space, tenant: tenant, is_calendar_public: idx.even?, is_double_booking_ok: (idx.even? && index.even?)
        space.allowed_time_slots << [morning, afternoon, evening]
        space.allowed_time_slots << [breakfast, brunch, lunch, dinner] if idx.even?
        space.save
        spaces << space
      end

      (-4..4).each do |shift|
        date_0  = Date.today + (shift*3).weeks
        date_1  = date_0 + 1.day
        date_2  = date_0 + 2.days
        date_3  = date_0 + 3.days
        date_4  = date_0 + 4.days
        date_5  = date_0 + 5.days
        # event = FactoryBot.create :event, category: categories.sample, tenant: tenant

        # schedule events within spaces
        spaces.each do |space|
          time_slots = space.allowed_time_slots

          # make space reservation through event
          FactoryBot.create(:reservation, space: space, event: events.first,  tenant: tenant, start_date: date_0, start_time_slot: time_slots.first, end_date: date_2, end_time_slot: time_slots.last)
          FactoryBot.create(:reservation, space: space, event: events.second, tenant: tenant, start_date: date_3, start_time_slot: time_slots.first, end_date: date_3, end_time_slot: time_slots.first)
          FactoryBot.create(:reservation, space: space, event: events.last,   tenant: tenant, start_date: date_3, start_time_slot: time_slots.last,  end_date: date_3, end_time_slot: time_slots.last)
          FactoryBot.create(:reservation, space: space, event: events.sample, tenant: tenant, start_date: date_5, start_time_slot: time_slots.first, end_date: date_5, end_time_slot: time_slots.sample)

          # make event reservation through space probably most common
          # if space.is_double_booking_ok
          #   event.reservations << FactoryBot.create(:reservation, space: space, tenant: tenant, date: date_2, time_slot: morning)
          #   event.reservations << FactoryBot.create(:reservation, space: space, tenant: tenant, date: date_2, time_slot: afternoon)

          #   event.reservations << FactoryBot.create(:reservation, space: space, tenant: tenant, date: date_3,  time_slot: breakfast)
          #   event.reservations << FactoryBot.create(:reservation, space: space, tenant: tenant, date: date_3,  time_slot: lunch)
          #   event.reservations << FactoryBot.create(:reservation, space: space, tenant: tenant, date: date_3,  time_slot: dinner)
          # end
          # event.save
        end
      end
    end
  end

end
