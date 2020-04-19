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
                        through(:reservations) }
    it { is_expected.to have_many(:allowed_time_slots).through(:space_time_slots) }
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
    let(:event1)    { event = FactoryBot.create :event, category: category1, tenant: tenant }
    let(:event2)    { event = FactoryBot.create :event, category: category2, tenant: tenant }
    let(:reservation1) { FactoryBot.create(:reservation, event: event1, space: space1, tenant: tenant, start_date: Date.today, start_time_slot: time1, end_date: Date.today, end_time_slot: time1) }
    let(:reservation2) { FactoryBot.create(:reservation, event: event2, space: space2, tenant: tenant, start_date: Date.today, start_time_slot: time2, end_date: Date.today, end_time_slot: time2) }
    it "#destroy_all" do
      expect(reservation1).to                   be
      expect(reservation2).to                   be
      described_class.destroy_all

      expect(Space.all).to                      eq []
      expect(SpaceTimeSlot.all).to              eq []
      expect(Reservation.all).to                eq []
      expect(Event.all.pluck(:id).sort).to      eq [event1.id, event2.id].sort
      expect(Category.all.pluck(:id).sort).to   eq [category1.id, category2.id].sort
      expect(TimeSlot.all.pluck(:id).sort).to   eq [time1.id, time2.id].sort
    end
    it "#destroy" do
      expect(reservation1).to   be
      expect(reservation2).to   be
      space1.destroy

      expect(Space.all).to                                  eq [space2]
      expect(Event.all.pluck(:id).sort).to                  eq [event1.id, event2.id].sort
      expect(TimeSlot.all.pluck(:id).sort).to               eq [time1.id, time2.id].sort
      expect(SpaceTimeSlot.all.pluck(:space_id)).to         eq [space2.id, space2.id]
      expect(SpaceTimeSlot.all.pluck(:time_slot_id)).to     eq [time1.id, time2.id]
      expect(Reservation.all.pluck(:space_id)).to           eq [space2.id]
      expect(Reservation.all.pluck(:event_id)).to           eq [event2.id]
    end
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
    # it { is_expected.to have_db_column(:is_calendar_public) }
    it { is_expected.to have_db_column(:is_double_booking_ok) }
  end

  context "model methods" do
    describe "#is_double_booking_ok?" do
      it "returns false by default" do
        model = FactoryBot.build :space
        expect(model.is_double_booking_ok?).to be_falsey
      end
      it "returns true when explicity set to true" do
        model = FactoryBot.build :space, is_double_booking_ok: true
        expect(model.is_double_booking_ok?).to be_truthy
      end
    end
  end


end
