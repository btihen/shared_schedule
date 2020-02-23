FactoryBot.define do
  factory :event_space_reservation do

    # temp value incase a tenant is not passed in
    transient do
      tenant  { FactoryBot.create :tenant }
    end

    host      { nil }
    date      { Date.today }
    event     { FactoryBot.create :event, tenant: tenant }
    space     { FactoryBot.create :space, tenant: tenant }
    time_slot { FactoryBot.create :time_slot, tenant: tenant }
  end
end
