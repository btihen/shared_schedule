FactoryBot.define do
  factory :event do
    event_title         { "MyString" }
    event_description   { nil }

    reason               { FactoryBot.create :reason }
    tenant              { FactoryBot.create :tenant  }
  end
end
