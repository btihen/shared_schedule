require 'rails_helper'

RSpec.describe Reason, type: :model do

  describe "factory functions" do
    it "generates a valid user" do
      model = FactoryBot.build :reason
      expect(model.valid?).to be true
    end
  end

  describe "relationships" do
    it { is_expected.to belong_to(:tenant) }
    it { is_expected.to have_many(:users).through(:user_interests) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:tenant) }
    it { is_expected.to validate_presence_of(:reason_name) }
  end

  describe "DB settings" do
    it { have_db_index(:reason_name) }
    it { is_expected.to have_db_column(:reason_description) }
  end

  # describe "model methods"

end
