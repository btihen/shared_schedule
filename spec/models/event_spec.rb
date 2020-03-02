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

  describe "destroy records - check dependents" do
    let(:tenant)  { FactoryBot.create :tenant }
    let(:reason1) { FactoryBot.create :reason, tenant: tenant }
    let(:reason2) { FactoryBot.create :reason, tenant: tenant }
    let(:time1)   { FactoryBot.create :time_slot, begin_time: '08:00', end_time: '12:00', tenant: tenant }
    let(:time2)   { FactoryBot.create :time_slot, begin_time: '13:00', end_time: '17:00', tenant: tenant }
    let(:space)   { space = FactoryBot.create :space, tenant: tenant
                    space.allowed_time_slots << [time1, time2]
                    space.save
                    space.reload
                  }
    let(:event_1) { event = FactoryBot.create :event, reason: reason1, tenant: tenant
                    event.event_space_reservations << EventSpaceReservation.create(date: Date.today, space: space, time_slot: time1)
                    event.save
                    event.reload
                  }
    let(:event_2) { event = FactoryBot.create :event, reason: reason2, tenant: tenant
                    event.event_space_reservations << EventSpaceReservation.create(date: Date.yesterday, space: space, time_slot: time2)
                    event.save
                    event.reload }
    it "#destroy_all" do
      expect(event_1).to            be
      expect(event_2).to            be
      described_class.destroy_all
      expect(Event.all).to                          eq [].sort
      expect(Space.all).to                          eq [space]
      expect(EventSpaceReservation.all).to          eq []
      expect(Reason.all.pluck(:id).sort).to         eq [reason1.id, reason2.id]
      expect(TimeSlot.all.pluck(:id).sort).to       eq [time1.id, time2.id].sort
      expect(SpaceTimeSlot.all.pluck(:id).sort).to  eq [SpaceTimeSlot.first.id, SpaceTimeSlot.last.id].sort
    end
    it "#destroy" do
      expect(event_1).to            be
      expect(event_2).to            be
      event_1.destroy
      expect(Space.all).to                          eq [space]
      expect(Event.all.pluck(:id)).to               eq [event_2.id].sort
      expect(Reason.all.pluck(:id).sort).to         eq [reason1.id, reason2.id]
      expect(TimeSlot.all.pluck(:id)).to            eq [TimeSlot.first.id, TimeSlot.last.id]
      expect(SpaceTimeSlot.all.pluck(:time_slot_id).sort).to          eq [TimeSlot.first.id, TimeSlot.last.id]
      expect(EventSpaceReservation.all.pluck(:time_slot_id).sort).to  eq [TimeSlot.last.id]
    end
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:reason) }
    it { is_expected.to validate_presence_of(:tenant) }
    it { is_expected.to validate_presence_of(:event_name) }
  end

  describe "DB settings" do
    it { have_db_index(:id) }
    it { is_expected.to have_db_column(:event_name) }
    it { is_expected.to have_db_column(:event_description) }
  end

  # describe "model methods"

end
