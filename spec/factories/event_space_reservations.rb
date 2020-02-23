FactoryBot.define do
  factory :event_space_reservation do
    host { "MyString" }
    date { "2020-02-15" }
    event { nil }
    space { nil }
  end
end
