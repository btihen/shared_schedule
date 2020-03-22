FactoryBot.define do
  factory :reservation do

    host            { nil }
    start_date      { Date.today }
    end_date        { start_date }
    tenant          { FactoryBot.build :tenant }
    event           { FactoryBot.create :event, tenant: tenant }
    space           { FactoryBot.create :space, tenant: tenant }
    start_time_slot { FactoryBot.create :time_slot, tenant: tenant }
    end_time_slot   { start_time_slot }
    start_date_time { DateTime.new(start_date.year, start_date.month, start_date.day, start_time_slot.begin_time.hour, start_time_slot.begin_time.min, 0) }
  end
end
