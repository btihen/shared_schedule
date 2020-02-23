FactoryBot.define do
  factory :user do
    # give email a sequence number before the '@''
    sequence(:email)      { |n| "#{Faker::Internet.email}".split('@').join("#{n}@") }
    first_name            { Faker::Name.first_name }
    last_name             { Faker::Name.last_name }
    password              { Faker::Internet.password(min_length: 8, max_length: 32) }
    tenant                { FactoryBot.create :tenant }
    user_role             { 'member' }
    user_title            { nil }
  end
end
