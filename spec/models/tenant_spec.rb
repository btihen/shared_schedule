require 'rails_helper'

RSpec.describe Tenant, type: :model do

  describe "factory functions" do
    it "generates a valid user" do
      model = FactoryBot.build :tenant
      expect(model.valid?).to be true
    end
  end

  describe "relationships" do
    it { is_expected.to have_many(:users) }
    it { is_expected.to have_many(:events) }
    it { is_expected.to have_many(:spaces) }
    it { is_expected.to have_many(:reasons) }
    it { is_expected.to have_many(:time_slots) }
  end

  describe "destroy records - check dependents" do
    let(:tenant1) { FactoryBot.create :tenant }
    let(:tenant2) { FactoryBot.create :tenant }
    let(:reason1) { FactoryBot.create :reason, tenant: tenant1 }
    let(:reason2) { FactoryBot.create :reason, tenant: tenant2 }
    let(:time1)   { FactoryBot.create :time_slot, begin_time: '08:00', end_time: '12:00', tenant: tenant1 }
    let(:time2)   { FactoryBot.create :time_slot, begin_time: '08:00', end_time: '12:00', tenant: tenant2 }
    let(:space1)  { space = FactoryBot.create :space, tenant: tenant1
                    space.allowed_time_slots << time1
                    space.save
                    space.reload
                  }
    let(:space2)  { space = FactoryBot.create :space, tenant: tenant2
                    space.allowed_time_slots << time2
                    space.save
                    space.reload
                  }
    let(:event1)  { event = FactoryBot.create :event, reason: reason1, tenant: tenant1 }
    let(:event2)  { event = FactoryBot.create :event, reason: reason2, tenant: tenant2 }
    let(:reservation1) { FactoryBot.create(:reservation, event: event1, space: space1, tenant: tenant1, start_date: Date.today, start_time_slot: time1, end_date: Date.today, end_time_slot: time1) }
    let(:reservation2) { FactoryBot.create(:reservation, event: event2, space: space2, tenant: tenant2, start_date: Date.today, start_time_slot: time2, end_date: Date.today, end_time_slot: time2) }
    it "#destroy_all" do
      expect(reservation1).to               be
      expect(reservation2).to               be
      described_class.destroy_all

      expect(Event.all).to                  eq []
      expect(Space.all).to                  eq []
      expect(Reason.all).to                 eq []
      expect(Tenant.all).to                 eq []
      expect(TimeSlot.all).to               eq []
      expect(SpaceTimeSlot.all).to          eq []
      expect(Reservation.all).to            eq []
    end
    it "#destroy" do
      expect(reservation1).to               be
      expect(reservation2).to               be
      tenant1.destroy

      expect(Space.all.pluck(:id)).to       eq [space2.id]
      expect(Event.all.pluck(:id)).to       eq [event2.id]
      expect(Reason.all.pluck(:id)).to      eq [reason2.id]
      expect(Tenant.all.pluck(:id)).to      eq [tenant2.id]
      expect(TimeSlot.all.pluck(:id)).to    eq [time2.id]
      expect(SpaceTimeSlot.all.pluck(:space_id).sort).to          eq [space2.id]
      expect(Reservation.all.pluck(:event_id).sort).to            eq [event2.id]
      expect(Reservation.all.pluck(:space_id).sort).to            eq [space2.id]
      expect(Reservation.all.pluck(:end_time_slot_id).sort).to    eq [time2.id]
      expect(Reservation.all.pluck(:start_time_slot_id).sort).to  eq [time2.id]
    end
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:tenant_name) }
  end

  describe "DB settings" do
    it { have_db_index(:tenant_name) }
    it { is_expected.to have_db_column(:tenant_tagline) }
    it { is_expected.to have_db_column(:tenant_site_url) }
    it { is_expected.to have_db_column(:tenant_logo_url) }
    it { is_expected.to have_db_column(:tenant_description) }
    it { is_expected.to have_db_column(:is_publicly_viewable) }
  end

  describe "model methods" do
    context "#is_publicly_viewable?" do
      it "returns false by default" do
        model = FactoryBot.build :tenant
        expect(model.is_publicly_viewable?).to be_falsey
      end
      it "returns true when explicity set to true" do
        model = FactoryBot.build :tenant, is_publicly_viewable: true
        expect(model.is_publicly_viewable?).to be_truthy
      end
    end

  end

end
