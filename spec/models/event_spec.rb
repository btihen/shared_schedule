require 'rails_helper'

RSpec.describe Event, type: :model do

  describe "factory functions" do
    it "generates a valid user" do
      model = FactoryBot.build :event
      expect(model.valid?).to be true
    end
  end

  describe "relationships" do
    it { is_expected.to belong_to(:category) }
    it { is_expected.to belong_to(:tenant) }
    it { is_expected.to have_many(:spaces).through(:reservations) }
    # it { is_expected.to have_many(:reserved_time_slots).through(:reservations) }
  end

  describe "destroy records - check dependents" do
    let(:tenant)        { FactoryBot.create :tenant }
    let(:category1)     { FactoryBot.create :category, tenant: tenant }
    let(:category2)     { FactoryBot.create :category, tenant: tenant }
    let(:time1)         { FactoryBot.create :time_slot, begin_time: '08:00', end_time: '12:00', tenant: tenant }
    let(:time2)         { FactoryBot.create :time_slot, begin_time: '13:00', end_time: '17:00', tenant: tenant }
    let(:space)         { space = FactoryBot.create :space, tenant: tenant
                          space.allowed_time_slots << [time1, time2]
                          space.save
                          space.reload
                        }
    let(:event1)        { event = FactoryBot.create :event, category: category1, tenant: tenant }
    let(:event2)        { event = FactoryBot.create :event, category: category2, tenant: tenant }
    let(:reservation1)  { FactoryBot.create(:reservation, event: event1, space: space, tenant: tenant, start_date: Date.yesterday, start_time_slot: time1, end_date: Date.yesterday, end_time_slot: time1) }
    let(:reservation2)  { FactoryBot.create(:reservation, event: event2, space: space, tenant: tenant, start_date: Date.yesterday, start_time_slot: time2, end_date: Date.yesterday, end_time_slot: time2) }
    it "#destroy_all" do
      expect(reservation1).to            be
      expect(reservation2).to            be
      described_class.destroy_all

      expect(Event.all).to                          eq [].sort
      expect(Space.all).to                          eq [space]
      expect(Reservation.all).to          eq []
      expect(Category.all.pluck(:id).sort).to         eq [category1.id, category2.id]
      expect(TimeSlot.all.pluck(:id).sort).to       eq [time1.id, time2.id].sort
      expect(SpaceTimeSlot.all.pluck(:id).sort).to  eq [SpaceTimeSlot.first.id, SpaceTimeSlot.last.id].sort
    end
    it "#destroy" do
      expect(reservation1).to            be
      expect(reservation2).to            be
      event1.destroy

      expect(Space.all).to                          eq [space]
      expect(Event.all.pluck(:id)).to               eq [event2.id].sort
      expect(Category.all.pluck(:id).sort).to         eq [category1.id, category2.id]
      expect(TimeSlot.all.pluck(:id)).to            eq [TimeSlot.first.id, TimeSlot.last.id]
      expect(Reservation.all.pluck(:start_time_slot_id).sort).to    eq [TimeSlot.last.id]
      expect(Reservation.all.pluck(:end_time_slot_id).sort).to      eq [TimeSlot.last.id]
    end
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:category) }
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
