FactoryBot.define do
  factory :event do
    sequence(:event_name) { |n| "#{Faker::Game.title} #{n}" }
    event_description     { nil }

    category              { FactoryBot.create :category }
    tenant                { FactoryBot.create :tenant  }
  end
end
