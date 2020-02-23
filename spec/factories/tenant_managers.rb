FactoryBot.define do
  factory :tenant_manager do
    tenant  { FactoryBot.create :tenant }
    manager { FactoryBot.create :user }
  end
end
