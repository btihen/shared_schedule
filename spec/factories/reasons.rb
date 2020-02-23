FactoryBot.define do
  factory :reason do
    sequence(:reason_name)         { |n| "#{Faker::Team.sport} #{n}" }
    sequence(:reason_description)  { nil }
    tenant                        { FactoryBot.create :tenant }
  end
end
