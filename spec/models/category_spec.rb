require 'rails_helper'

RSpec.describe Category, type: :model do

  describe "factory functions" do
    it "generates a valid user" do
      model = FactoryBot.build :category
      expect(model.valid?).to be true
    end
  end

  describe "relationships" do
    it { is_expected.to belong_to(:tenant) }
    it { is_expected.to have_many(:users).through(:user_interests) }
  end

  describe "destroy records - check dependents" do
    let(:tenant)    { FactoryBot.create :tenant }
    let(:category1) { FactoryBot.create :category, tenant: tenant }
    let(:category2) { FactoryBot.create :category, tenant: tenant }
    let(:time1)     { FactoryBot.create :time_slot, begin_time: '08:00', end_time: '12:00', tenant: tenant }
    let(:time2)     { FactoryBot.create :time_slot, begin_time: '13:00', end_time: '17:00', tenant: tenant }
    let(:space1)    { space = FactoryBot.create :space, tenant: tenant
                      space.allowed_time_slots << [time1, time2]
                      space.save
                      space.reload
                    }
    let(:space2)    { space = FactoryBot.create :space, tenant: tenant
                      space.allowed_time_slots << [time1, time2]
                      space.save
                      space.reload
                    }
    let(:event1)    { event = FactoryBot.create :event, category: category1, tenant: tenant
                      FactoryBot.create(:reservation, event: event, space: space1, tenant: tenant, start_date: Date.today, start_time_slot: time1, end_date: Date.today, end_time_slot: time1)
                      FactoryBot.create(:reservation, event: event, space: space2, tenant: tenant, start_date: Date.today, start_time_slot: time2, end_date: Date.today, end_time_slot: time2)
                    }
    let(:event2)    { event = FactoryBot.create :event, category: category2, tenant: tenant
                      FactoryBot.create(:reservation, event: event, space: space1, tenant: tenant, start_date: Date.tomorrow, start_time_slot: time1, end_date: Date.tomorrow, end_time_slot: time1)
                      FactoryBot.create(:reservation, event: event, space: space2, tenant: tenant, start_date: Date.yesterday, start_time_slot: time2, end_date: Date.yesterday, end_time_slot: time2)
                    }
    it "#destroy_all" do
      expect(event1).to                     be
      expect(event2).to                     be
      described_class.destroy_all

      expect(Category.all).to                   eq []
      expect(Reservation.all).to  eq []
      expect(Space.all.pluck(:id).sort).to      eq [space1.id, space2.id].sort
      expect(TimeSlot.all.pluck(:id).sort).to   eq [time1.id, time2.id].sort
      expect(SpaceTimeSlot.all.pluck(:space_id).sort).to      eq [space1.id, space2.id, space1.id, space2.id].sort
      expect(SpaceTimeSlot.all.pluck(:time_slot_id).sort).to  eq [time1.id, time1.id, time2.id, time2.id].sort
    end
    it "#destroy" do
      expect(event1).to   be
      expect(event2).to   be
      category1.destroy

      expect(Category.all).to                   eq [category2]
      expect(Space.all.pluck(:id).sort).to      eq [space1.id, space2.id].sort
      expect(TimeSlot.all.pluck(:id).sort).to   eq [time1.id, time2.id].sort
      expect(SpaceTimeSlot.all.pluck(:space_id).sort).to          eq [space1.id, space2.id, space1.id, space2.id].sort
      expect(SpaceTimeSlot.all.pluck(:time_slot_id).sort).to      eq [time1.id, time1.id, time2.id, time2.id].sort
      expect(Reservation.all.pluck(:space_id).sort).to  eq [space1.id, space2.id].sort
    end
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:tenant) }
    it { is_expected.to validate_presence_of(:category_name) }
  end

  describe "DB settings" do
    it { have_db_index(:category_name) }
    it { is_expected.to have_db_column(:category_description) }
  end

  # describe "model methods"

end
