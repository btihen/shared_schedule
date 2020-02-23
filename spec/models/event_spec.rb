require 'rails_helper'

RSpec.describe Event, type: :model do

  describe "factory functions" do
    it "generates a valid user" do
      model = FactoryBot.build :event
      expect(model.valid?).to be true
    end
  end

  describe "relationships" do
    it { is_expected.to belong_to(:reason) }
    it { is_expected.to belong_to(:tenant) }
    it { is_expected.to have_many(:spaces).through(:event_space_reservations) }
    it { is_expected.to have_many(:reserved_time_slots).through(:event_space_reservations) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:reason) }
    it { is_expected.to validate_presence_of(:tenant) }
    it { is_expected.to validate_presence_of(:event_title) }
  end

  describe "DB settings" do
    it { have_db_index(:id) }
    it { is_expected.to have_db_column(:event_title) }
    it { is_expected.to have_db_column(:event_description) }
  end

  # describe "model methods"

end
