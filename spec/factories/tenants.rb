FactoryBot.define do
  factory :tenant do
    sequence(:tenant_name)  { |n| "#{Faker::Company.name} #{n}" }
    tenant_tagline          { Faker::Company.catch_phrase }
    tenant_site_url         { Faker::Internet.url }
    # https://loremflickr.com/96/96/sports
    tenant_logo_url         { Faker::LoremFlickr.image(size: "96x96", search_terms: ["#{Faker::Team.sport}"]) }
    tenant_description      { Faker::Lorem.paragraph(sentence_count: rand(1..3)) }
  end
end
