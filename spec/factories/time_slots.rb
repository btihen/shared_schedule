FactoryBot.define do
  factory :time_slot do
    hour_b = Faker::Number.within(range: 1..18)
    hour_e = Faker::Number.within(range: (hour_b+1)..20)
    sequence(:time_slot_name) { |n| "#{Faker::Name.last_name} #{n}" }
    begin_time                { '08:00' }
    end_time                  { '12:00' }
    # sequence(:begin_time)     { |n| "#{rand(0..20).to_i}:00" }
    # # sequence(:end_time)       { |n| "#{n+1}:00" }
    # end_time                  { "#{begin_time.split(':').first.to_i+rand(1..3)}:00" }
    tenant                    { FactoryBot.create :tenant }
  end
end
