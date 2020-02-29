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

  describe "destroy records - check dependents" do
    let(:tenant)  { FactoryBot.create :tenant }
    let(:reason1) { FactoryBot.create :reason, tenant: tenant }
    let(:reason2) { FactoryBot.create :reason, tenant: tenant }
    let(:time1)   { FactoryBot.create :time_slot, tenant: tenant }
    let(:time2)   { FactoryBot.create :time_slot, tenant: tenant }
    let(:space1)  { space = FactoryBot.create :space, tenant: tenant
                    space.allowed_time_slots << [time1, time2]
                    space.save
                    space.reload
                  }
    let(:space2)  { space = FactoryBot.create :space, tenant: tenant
                    space.allowed_time_slots << [time1, time2]
                    space.save
                    space.reload
                  }
    let(:event1)  { event = FactoryBot.create :event, reason: reason1, tenant: tenant
                    event.event_space_reservations << EventSpaceReservation.create(date: Date.today, space: space1, time_slot: time1)
                    event.event_space_reservations << EventSpaceReservation.create(date: Date.today, space: space2, time_slot: time2)
                    event.save
                    event.reload
                  }
    let(:event2)  { event = FactoryBot.create :event, reason: reason2, tenant: tenant
                    event.event_space_reservations << EventSpaceReservation.create(date: Date.tomorrow, space: space1, time_slot: time1)
                    event.event_space_reservations << EventSpaceReservation.create(date: Date.yesterday, space: space2, time_slot: time2)
                    event.save
                    event.reload }
    it "#destroy_all" do
      expect(event1).to                         be
      expect(event2).to                         be
      described_class.destroy_all
      expect(Space.all).to                      eq []
      expect(SpaceTimeSlot.all).to              eq []
      expect(EventSpaceReservation.all).to      eq []
      expect(Event.all.pluck(:id).sort).to      eq [event1.id, event2.id].sort
      expect(Reason.all.pluck(:id).sort).to     eq [reason1.id, reason2.id].sort
      expect(TimeSlot.all.pluck(:id).sort).to   eq [time1.id, time2.id].sort
    end
    it "#destroy" do
      expect(event1).to   be
      expect(event2).to   be
      space1.destroy
      expect(Space.all).to                                  eq [space2]
      expect(Event.all.pluck(:id).sort).to                  eq [event1.id, event2.id].sort
      expect(TimeSlot.all.pluck(:id).sort).to               eq [time1.id, time2.id].sort
      expect(SpaceTimeSlot.all.pluck(:space_id)).to         eq [space2.id, space2.id]
      expect(SpaceTimeSlot.all.pluck(:time_slot_id)).to     eq [time1.id, time2.id]
      expect(EventSpaceReservation.all.pluck(:space_id)).to eq [space2.id, space2.id]
      expect(EventSpaceReservation.all.pluck(:event_id)).to eq [event1.id, event2.id]
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
    it { is_expected.to have_db_column(:is_double_booking_ok) }
  end

  # describe "model methods"

end
