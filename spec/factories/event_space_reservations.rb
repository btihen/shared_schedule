FactoryBot.define do
  factory :event_space_reservation do

    transient do
      tenant  { FactoryBot.build :tenant }
    end

    host      { nil }
    date      { Date.today }
    event     { FactoryBot.create :event, tenant: tenant }
    space     { FactoryBot.create :space, tenant: tenant }
    time_slot { FactoryBot.create :time_slot, tenant: tenant }
  end
end
