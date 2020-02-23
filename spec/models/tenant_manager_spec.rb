require 'rails_helper'

RSpec.describe TenantManager, type: :model do

  describe "factory functions" do
    it "generates a valid user" do
      model = FactoryBot.build :tenant_manager
      expect(model.valid?).to be true
    end
  end

  describe "relationships" do
    it { is_expected.to belong_to(:tenant) }
    it { is_expected.to belong_to(:manager) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:tenant) }
    it { is_expected.to validate_presence_of(:manager) }
  end

  describe "DB settings" do
    it { have_db_index(:tenant) }
    it { have_db_index(:manager) }
  end

  # describe "model methods"

end
