module SeedDemoGroup
  def self.create
    tenant    = FactoryBot.create :tenant,
                                  tenant_name: "Shared Schedules",
                                  tenant_tagline: "Try it out!  Where groups schedule shared resources.",
                                  tenant_description: "Data reset every 24hrs",
                                  # tenant_logo_url: "https://loremflickr.com/g/96/96/bern",
                                  tenant_site_url: "http://localhost:3000/",
                                  is_demo_tenant: true,
                                  is_publicly_viewable: true

    breakfast = TimeSlot.create time_slot_name: "Breakfast", begin_time: "06:00", end_time: "10:00", tenant: tenant
    morning   = TimeSlot.create time_slot_name: "Morning",   begin_time: "08:00", end_time: "12:00", tenant: tenant
    brunch    = TimeSlot.create time_slot_name: "Brunch",    begin_time: "10:00", end_time: "15:00", tenant: tenant
    lunch     = TimeSlot.create time_slot_name: "Lunch",     begin_time: "11:00", end_time: "14:00", tenant: tenant
    afternoon = TimeSlot.create time_slot_name: "Afternoon", begin_time: "13:00", end_time: "18:00", tenant: tenant
    dinner    = TimeSlot.create time_slot_name: "Dinner",    begin_time: "16:00", end_time: "20:00", tenant: tenant
    evening   = TimeSlot.create time_slot_name: "Evening",   begin_time: "18:00", end_time: "22:00", tenant: tenant

    spaces = []
    spaces << FactoryBot.create(:space, space_name: "Single Usage Demo", tenant: tenant, is_calendar_public: true, is_double_booking_ok: false)
    spaces << FactoryBot.create(:space, space_name: "Multi-Usage Demo",  tenant: tenant, is_calendar_public: true, is_double_booking_ok: true)

    spaces.each do |space|
      space.allowed_time_slots << [morning, afternoon, evening]
      space.allowed_time_slots << [breakfast, brunch, lunch, dinner]  if [true, false].sample
      space.save
    end

    create_events
  end

  def self.reset_events
    # identify objects we are working with
    tenant        = Tenant.find_by(is_demo_tenant: true)

    error_message = "DemoGroup not found please run: `bin/rails runner SeedDemoGroup.create`"
    raise StandardError, error_message  if tenant.blank?

    # destroy all Demo Categories and Events
    categories    = Category.where(tenant_id: tenant.id)
    categories.destroy_all

    # re-create all events
    create_events
  end

  def self.create_events
    tenant     = Tenant.find_by(is_demo_tenant: true)
    spaces     = Space.where(tenant_id: tenant.id)
    # error_message = "DemoGroup not found please run: `bin/rails runner SeedDemoGroup.create`"

    # recreate all Demo Categories and Events
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

    (-4..4).each do |shift|
      date_0  = Date.today + (shift*2).weeks
      date_1  = date_0 + 1.day
      date_2  = date_0 + 2.days
      date_3  = date_0 + 3.days
      date_4  = date_0 + 4.days
      date_5  = date_0 + 5.days
      # event = FactoryBot.create :event, category: categories.sample, tenant: tenant

      # schedule events within spaces
      spaces.each do |space|

        time_slots = space.allowed_time_slots

        FactoryBot.create(:reservation, space: space, event: events.first,  tenant: tenant, start_date: date_0, start_time_slot: time_slots.second, end_date: date_2, end_time_slot: time_slots.last)
        FactoryBot.create(:reservation, space: space, event: events.second, tenant: tenant, start_date: date_3, start_time_slot: time_slots.first,  end_date: date_3, end_time_slot: time_slots.second)
        FactoryBot.create(:reservation, space: space, event: events.last,   tenant: tenant, start_date: date_3, start_time_slot: time_slots.last,   end_date: date_3, end_time_slot: time_slots.last)
        FactoryBot.create(:reservation, space: space, event: events.sample, tenant: tenant, start_date: date_5, start_time_slot: time_slots.first,  end_date: date_5, end_time_slot: time_slots.sample)
        # space.save
      end
    end
  end

end
