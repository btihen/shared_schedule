FactoryBot.define do
  factory :tenant do
    sequence(:tenant_name)  { |n| "#{Faker::Company.name} #{n}" }
    tenant_tagline          { Faker::Company.catch_phrase }
    tenant_site_url         { Faker::Internet.url }
    is_publicly_viewable    { false }
    is_demo_tenant          { false }
    # https://loremflickr.com/96/96/sports
    tenant_logo_url         { Faker::LoremFlickr.image(size: "96x96", search_terms: ["#{Faker::Team.sport}"]) }
    tenant_description      { Faker::Lorem.paragraph(sentence_count: rand(1..3)) }

    trait :public do
      is_publicly_viewable  { true }
    end

    trait :demo_group do
      sequence(:tenant_name)  { "DemoGroup" }
      tenant_tagline          { "Try it" }
      tenant_site_url         { Faker::Internet.url }
      is_publicly_viewable    { true }
      is_demo_tenant          { true }
      # https://loremflickr.com/96/96/sports
      tenant_logo_url         { Faker::LoremFlickr.image(size: "96x96", search_terms: ["#{Faker::Team.sport}"]) }
      tenant_description      { "Reset every 24 hrs" }
    end

  end


end
