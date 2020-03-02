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

  describe "destroy records - check dependents" do
    let(:tenant)  { FactoryBot.create :tenant }
    let(:time1)   { FactoryBot.create :time_slot, begin_time: '08:00', end_time: '12:00', tenant: tenant }
    let(:time2)   { FactoryBot.create :time_slot, begin_time: '13:00', end_time: '17:00', tenant: tenant }
    let(:space)   { space = FactoryBot.create :space, tenant: tenant
                    space.allowed_time_slots << [time1, time2]
                    space.save
                    space.reload
                  }
    let(:event_1) { event = FactoryBot.create :event, tenant: tenant
                    time1 = TimeSlot.first
                    time2 = TimeSlot.last
                    event.event_space_reservations << EventSpaceReservation.create(date: Date.today, space: space, time_slot: time1)
                    event.event_space_reservations << EventSpaceReservation.create(date: Date.today, space: space, time_slot: time2)
                    event.save
                    event.reload
                  }
    let(:event_2) { event = FactoryBot.create :event, tenant: tenant
                    time1 = TimeSlot.first
                    time2 = TimeSlot.last
                    event.event_space_reservations << EventSpaceReservation.create(date: Date.tomorrow, space: space, time_slot: time1)
                    event.event_space_reservations << EventSpaceReservation.create(date: Date.yesterday, space: space, time_slot: time2)
                    event.save
                    event.reload }
    it "#destroy_all" do
      expect(event_1).to            be
      expect(event_2).to            be
      described_class.destroy_all
      expect(Space.all).to                  eq [space]
      expect(TimeSlot.all).to               eq []
      expect(SpaceTimeSlot.all).to          eq []
      expect(Event.all.pluck(:id).sort).to  eq [event_1.id, event_2.id].sort
      expect(EventSpaceReservation.all).to  eq []
    end
    it "#destroy" do
      expect(event_1).to      be
      expect(event_2).to      be
      TimeSlot.first.destroy
      expect(Space.all).to                  eq [space]
      expect(TimeSlot.all.pluck(:id)).to    eq [TimeSlot.last.id]
      expect(Event.all.pluck(:id).sort).to  eq [event_1.id, event_2.id].sort
      expect(SpaceTimeSlot.all.pluck(:time_slot_id).sort).to          eq [TimeSlot.last.id]
      expect(EventSpaceReservation.all.pluck(:time_slot_id).sort).to  eq [TimeSlot.last.id]
    end
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:time_slot_name) }
    it { is_expected.to validate_presence_of(:begin_time) }
    it { is_expected.to validate_presence_of(:end_time) }
    it { is_expected.to validate_presence_of(:tenant) }
  end

  describe "DB settings" do
    it { have_db_index(:time_slot_name) }
  end

  # describe "model methods"

end
