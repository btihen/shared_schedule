FactoryBot.define do
  factory :space_time_slot do

    transient do
      tenant    { FactoryBot.build :tenant }
    end

    space       { FactoryBot.create :space, tenant: tenant }
    time_slot   { FactoryBot.create :time_slot, tenant: tenant }
  end
end
