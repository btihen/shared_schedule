FactoryBot.define do
  factory :event do
    sequence(:event_name) { |n| "#{Faker::Game.title} #{n}" }
    event_description     { nil }

    reason                { FactoryBot.create :reason }
    tenant                { FactoryBot.create :tenant  }
  end
end
