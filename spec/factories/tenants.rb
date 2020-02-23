FactoryBot.define do
  factory :tenant do
    sequence(:tenant_name)  { |n| "#{Faker::Company.name} #{n}" }
    tenant_tagline          { nil }
    tenant_site_url         { nil }
    tenant_logo_url         { nil }
    tenant_description      { nil }
  end
end
