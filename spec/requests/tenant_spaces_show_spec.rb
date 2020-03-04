require 'rails_helper'
# support for: .at_beginning_of_month & .next_month
require 'active_support'

RSpec.describe "Spaces Show", type: :request do

  let(:today)             { Date.today }
  let(:end_last_month)    { today.at_beginning_of_month - 1.day }
  let(:start_this_month)  { today.at_beginning_of_month }
  let(:middle_this_month) { today.at_beginning_of_month + 15.days }
  let(:end_this_month)    { today.at_beginning_of_month.next_month - 1.day }
  let(:start_next_month)  { today.at_beginning_of_month.next_month }
  let(:tenant)            { FactoryBot.create :tenant }
  let(:reason1)           { FactoryBot.create :reason, tenant: tenant }
  let(:reason2)           { FactoryBot.create :reason, tenant: tenant }
  let(:morning)           { FactoryBot.create :time_slot, time_slot_name: 'morning',   begin_time: '08:00', end_time: '12:00', tenant: tenant }
  let(:brunch)            { FactoryBot.create :time_slot, time_slot_name: 'brunch',    begin_time: '10:00', end_time: '14:00', tenant: tenant }
  let(:afternoon)         { FactoryBot.create :time_slot, time_slot_name: 'afternoon', begin_time: '13:00', end_time: '17:00', tenant: tenant }
  let(:evening)           { FactoryBot.create :time_slot, time_slot_name: 'evening',   begin_time: '18:00', end_time: '22:00', tenant: tenant }
  let(:space1)            { space = FactoryBot.create :space, tenant: tenant
                            space.allowed_time_slots << [morning, brunch, afternoon, evening]
                            space.save
                            space.reload
                          }
  let(:start_event)       { event = FactoryBot.create :event, reason: reason1, tenant: tenant
                            event.reservations << Reservation.create(date: end_last_month,   space: space1, time_slot: brunch)
                            event.reservations << Reservation.create(date: end_last_month,   space: space1, time_slot: evening)
                            event.reservations << Reservation.create(date: start_this_month, space: space1, time_slot: morning)
                            event.reservations << Reservation.create(date: start_this_month, space: space1, time_slot: afternoon)
                            event.reservations << Reservation.create(date: start_this_month, space: space1, time_slot: evening)
                            event.save
                            event.reload
                          }
  let(:middle_event)      { event = FactoryBot.create :event, reason: reason2, tenant: tenant
                            event.reservations << Reservation.create(date: middle_this_month - 1.day, space: space1, time_slot: evening)
                            event.reservations << Reservation.create(date: middle_this_month,         space: space1, time_slot: evening)
                            event.reservations << Reservation.create(date: middle_this_month + 1.day, space: space1, time_slot: morning)
                            event.reservations << Reservation.create(date: middle_this_month + 1.day, space: space1, time_slot: afternoon)
                            event.reservations << Reservation.create(date: middle_this_month + 1.day, space: space1, time_slot: evening)
                            event.save
                            event.reload
                          }
  let(:end_event)         { event = FactoryBot.create :event, reason: reason3, tenant: tenant
                            event.reservations << Reservation.create(date: end_this_month,   space: space1, time_slot: brunch)
                            event.reservations << Reservation.create(date: end_this_month,   space: space1, time_slot: evening)
                            event.reservations << Reservation.create(date: start_next_month, space: space1, time_slot: morning)
                            event.reservations << Reservation.create(date: start_next_month, space: space1, time_slot: afternoon)
                            event.reservations << Reservation.create(date: start_next_month, space: space1, time_slot: evening)
                            event.save
                            event.reload
                          }

  describe "GET tenant/:tenant_id/spaces/:id" do
    it "works! (now write some real specs)" do
      get tenant_spaces_path(id: space1.id, tenant_id: tenant.id)
      expect(response).to have_http_status(200)
    end
  end
end
