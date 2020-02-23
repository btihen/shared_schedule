FactoryBot.define do
  factory :space do
    sequence(:space_name) { |n| "#{Faker::Company.name} #{n}" }
    space_location        { nil }
    time_zone             { Faker::Address.time_zone }
    tenant                { FactoryBot.create :tenant }
  end
end
