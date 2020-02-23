FactoryBot.define do
  factory :time_slot do
    hour_b = Faker::Number.within(range: 1..18)
    hour_e = Faker::Number.within(range: (hour_b+1)..20)
    sequence(:time_slot_name) { |n| "#{Faker::Name.last_name} #{n}" }
    sequence(:begin_time)     { |n| "#{n}:00" }
    end_time                  { "#{begin_time.split(':').first.to_i+1}:00" }
    tenant                    { FactoryBot.create :tenant }
  end
end
