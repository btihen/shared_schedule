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
    # it { is_expected.to have_many(:users) }
    # it { is_expected.to have_many(:managers).through(:tenant_managers) }
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
