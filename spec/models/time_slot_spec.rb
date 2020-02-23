require 'rails_helper'

RSpec.describe TimeSlot, type: :model do

  describe "factory functions" do
    it "generates a valid user" do
      model = FactoryBot.build :time_slot
      expect(model.valid?).to be true
    end
  end

  describe "relationships" do
    it { is_expected.to belong_to(:tenant) }
  end

  describe "destroy records - check dependents" do
    let(:tenant)  { FactoryBot.create :tenant }
    let(:time_1)  { FactoryBot.create :time_slot, tenant: tenant }
    let(:time_2)  { FactoryBot.create :time_slot, tenant: tenant }
    it "#destroy_all" do
      expect(time_1).to             be
      expect(time_2).to             be
      described_class.destroy_all
      expect(Tenant.all).to         eq [tenant]
      expect(TimeSlot.all).to       eq []
    end
    it "#destroy" do
      expect(time_1).to             be
      expect(time_2).to             be
      time_1.destroy
      expect(Tenant.all).to         eq [tenant]
      expect(TimeSlot.all.pluck(:id)).to eq [time_2.id]
    end
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:time_slot_name) }
    it { is_expected.to validate_presence_of(:begin_time) }
    it { is_expected.to validate_presence_of(:end_time) }
    it { is_expected.to validate_presence_of(:tenant) }
  end

  describe "DB settings" do
    it { have_db_index(:time_slot_name) }
  end

  # describe "model methods"

end
