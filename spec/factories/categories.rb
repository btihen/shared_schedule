FactoryBot.define do
  factory :category do
    sequence(:category_name)         { |n| "#{Faker::Team.sport} #{n}" }
    sequence(:category_description)  { nil }
    tenant                        { FactoryBot.create :tenant }
  end
end
