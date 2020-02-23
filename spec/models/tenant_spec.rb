require 'rails_helper'

RSpec.describe Tenant, type: :model do

  describe "factory functions" do
    it "generates a valid user" do
      model = FactoryBot.build :tenant
      expect(model.valid?).to be true
    end
  end

  describe "relationships" do
    it { is_expected.to have_many(:users) }
    it { is_expected.to have_many(:events) }
    it { is_expected.to have_many(:spaces) }
    it { is_expected.to have_many(:reasons) }
    it { is_expected.to have_many(:managers).through(:tenant_managers) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:tenant_name) }
  end

  describe "DB settings" do
    it { have_db_index(:tenant_name) }
    it { is_expected.to have_db_column(:tenant_tagline) }
    it { is_expected.to have_db_column(:tenant_site_url) }
    it { is_expected.to have_db_column(:tenant_logo_url) }
    it { is_expected.to have_db_column(:tenant_description) }
  end

  # describe "model methods"

end
