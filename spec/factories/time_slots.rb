FactoryBot.define do
  factory :time_slot do
    hour_b = Faker::Number.within(range: 1..18)
    hour_e = Faker::Number.within(range: (hour_b+1)..20)
    sequence(:time_slot_name) { |n| "#{Faker::Name.last_name} #{n}" }
    begin_time                { "#{hour_b}:00" }
    end_time                  { "#{hour_e}:00" }
    tenant                    { FactoryBot.create :tenant }
  end
end
