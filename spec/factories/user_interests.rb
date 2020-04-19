FactoryBot.define do
  factory :user_interest do
    category  { FactoryBot.create :category }
    user      { FactoryBot.create :user }
  end
end
