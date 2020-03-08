FactoryBot.define do
  factory :reservation do

    transient do
      tenant  { FactoryBot.build :tenant }
    end

    host            { nil }
    start_date      { Date.today }
    end_date        { start_date }
    event           { FactoryBot.create :event, tenant: tenant }
    space           { FactoryBot.create :space, tenant: tenant }
    start_time_slot { FactoryBot.create :time_slot, tenant: tenant }
    end_time_slot   { start_time_slot }
  end
end
