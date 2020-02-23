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

  describe "validations" do
    it { is_expected.to validate_presence_of(:time_slot_name) }
    it { is_expected.to validate_presence_of(:begin_time) }
    it { is_expected.to validate_presence_of(:end_time) }
    it { is_expected.to validate_presence_of(:tenant) }
    # TODO: * begin / end time checks
    #       * no time with over lapping ranges
  end

  describe "DB settings" do
    it { have_db_index(:time_slot_name) }
    # it { is_expected.to have_db_column(:reason_description) }
  end

  # describe "model methods"

end
