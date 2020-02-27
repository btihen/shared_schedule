FactoryBot.define do
  factory :user_interest do
    reason  { FactoryBot.create :reason }
    user    { FactoryBot.create :user }
  end
end
