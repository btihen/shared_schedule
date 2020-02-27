require 'rails_helper'

RSpec.describe SpaceTimeSlot, type: :model do

  describe "factory functions" do
    it "generates a valid user" do
      model = FactoryBot.build :space_time_slot
      expect(model.valid?).to be true
    end
  end

  describe "relationships" do
    it { is_expected.to belong_to(:space) }
    it { is_expected.to belong_to(:time_slot) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:space) }
    it { is_expected.to validate_presence_of(:time_slot) }
  end

  describe "DB settings" do
    it { have_db_index(:space) }
    it { have_db_index(:time_slot) }
  end

  # describe "model methods"

end
