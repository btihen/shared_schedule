FactoryBot.define do
  factory :event do
    sequence(:event_title)  { |n| "#{Faker::Game.title} #{n}" }
    event_description       { nil }

    reason                  { FactoryBot.create :reason }
    tenant                  { FactoryBot.create :tenant  }
  end
end
