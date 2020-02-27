require 'rails_helper'

RSpec.describe EventSpaceReservation, type: :model do

  describe "factory functions" do
    it "generates a valid user" do
      model = FactoryBot.build :event_space_reservation
      expect(model.valid?).to be true
    end
  end

  describe "relationships" do
    it { is_expected.to belong_to(:event) }
    it { is_expected.to belong_to(:space) }
    it { is_expected.to belong_to(:time_slot) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:date) }
    it { is_expected.to validate_presence_of(:event) }
    it { is_expected.to validate_presence_of(:space) }
    it { is_expected.to validate_presence_of(:time_slot) }
  end

  describe "DB settings" do
    it { have_db_index(:date) }
    it { have_db_index(:event) }
    it { have_db_index(:space) }
    it { have_db_index(:time_slot) }
    it { is_expected.to have_db_column(:host) }
  end

  # describe "model methods"

end
