require 'rails_helper'

RSpec.describe UserInterest, type: :model do

  describe "factory functions" do
    it "generates a valid user" do
      model = FactoryBot.build :user_interest
      expect(model.valid?).to be true
    end
  end

  describe "relationships" do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:reason) }
  end

  describe "destroy records - check dependents" do
    let(:tenant)  { FactoryBot.create :tenant }
    let(:reason)  { FactoryBot.create :reason, tenant: tenant }
    let(:user_1)  { FactoryBot.create :user, interests: [reason], tenant: tenant }
    let(:user_2)  { FactoryBot.create :user, interests: [reason], tenant: tenant }
    before do
      tenant.managers << user_1
      tenant.managers << user_2
      tenant.save
    end
    it "#destroy_all" do
      expect(user_1).to             be
      expect(user_2).to             be
      described_class.destroy_all
      expect(User.all).to           eq [user_1, user_2]
      expect(Reason.all).to         eq [reason]
      expect(Tenant.all).to         eq [tenant]
      expect(UserInterest.all).to   eq []
      expect(TenantManager.all.pluck(:manager_id)).to eq [user_1.id, user_2.id]
    end
    it "#destroy" do
      expect(user_1).to       be
      expect(user_2).to       be
      user_1.destroy
      expect(User.all).to     eq [user_2]
      expect(Reason.all).to   eq [reason]
      expect(Tenant.all).to   eq [tenant]
      expect(UserInterest.all.pluck(:user_id)).to     eq UserInterest.where(user: user_2).all.pluck(:user_id)
      expect(TenantManager.all.pluck(:manager_id)).to eq TenantManager.where(manager: user_2).all.pluck(:manager_id)
    end
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:user) }
    it { is_expected.to validate_presence_of(:reason) }
  end

  describe "DB settings" do
    it { have_db_index(:user) }
    it { have_db_index(:reason) }
  end

  # describe "model methods"

end
