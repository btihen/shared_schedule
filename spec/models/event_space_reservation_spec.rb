require 'rails_helper'

RSpec.describe EventSpaceReservation, type: :model do

  describe "factory functions" do
    it "generates a valid user" do
      model = FactoryBot.build :user
      expect(model.valid?).to be true
    end
  end

  describe "relationships" do
    it { is_expected.to belong_to(:tenant) }
    it { is_expected.to have_many(:interests).through(:user_interests) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:tenant) }
    it { is_expected.to validate_presence_of(:password) }
    it { is_expected.to validate_presence_of(:last_name) }
    it { is_expected.to validate_presence_of(:first_name) }
    it { is_expected.to validate_presence_of(:user_role) }
    it { is_expected.to validate_inclusion_of(:user_role).
                        in_array(ApplicationHelper::USER_ROLES) }
  end

  describe "DB settings" do
    it { have_db_index(:email) }
    it { is_expected.to have_db_column(:user_title) }
    it { is_expected.to have_db_column(:encrypted_password) }
  end

  # describe "model methods"

end
