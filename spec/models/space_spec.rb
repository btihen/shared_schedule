require 'rails_helper'

RSpec.describe Space, type: :model do

  describe "factory functions" do
    it "generates a valid user" do
      model = FactoryBot.build :space
      expect(model.valid?).to be true
    end
  end

  describe "relationships" do
    it { is_expected.to belong_to(:tenant) }
    it { is_expected.to have_many(:events).
                        through(:event_space_reservations) }
    it { is_expected.to have_many(:reserved_time_slots).
                        through(:event_space_reservations) }
    it { is_expected.to have_many(:allowed_time_slots).
                        through(:space_time_slots) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:tenant) }
    it { is_expected.to validate_presence_of(:space_name) }
    it { is_expected.to validate_presence_of(:time_zone) }
    it { is_expected.to validate_inclusion_of(:time_zone).
                        in_array(ApplicationHelper::TIME_ZONES_IN) }
  end

  describe "DB settings" do
    it { have_db_index(:space_name) }
    it { is_expected.to have_db_column(:space_location) }
  end

  # describe "model methods"

end
