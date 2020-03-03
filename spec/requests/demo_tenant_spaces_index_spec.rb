require 'rails_helper'
# support for: .at_beginning_of_month & .next_month
require 'active_support'

RSpec.describe "Spaces Show", type: :request do

  let(:today)             { Date.today }
  let(:end_last_month)    { today.at_beginning_of_month - 1.day }
  let(:start_this_month)  { today.at_beginning_of_month }
  let(:middle_this_month) { today.at_beginning_of_month + 14.days }
  let(:end_this_month)    { today.at_beginning_of_month.next_month - 1.day }
  let(:start_next_month)  { today.at_beginning_of_month.next_month }
  let(:tenant)            { FactoryBot.create :tenant, tenant_name: "DemoGroup", tenant_tagline: "Try it out", tenant_description: "Reset every 24 hours" }
  let(:reason1)           { FactoryBot.create :reason, tenant: tenant }
  let(:reason2)           { FactoryBot.create :reason, tenant: tenant }
  let(:morning)           { FactoryBot.create :time_slot, time_slot_name: 'morning',   begin_time: '08:00', end_time: '12:00', tenant: tenant }
  let(:brunch)            { FactoryBot.create :time_slot, time_slot_name: 'brunch',    begin_time: '10:00', end_time: '14:00', tenant: tenant }
  let(:afternoon)         { FactoryBot.create :time_slot, time_slot_name: 'afternoon', begin_time: '13:00', end_time: '17:00', tenant: tenant }
  let(:evening)           { FactoryBot.create :time_slot, time_slot_name: 'evening',   begin_time: '18:00', end_time: '22:00', tenant: tenant }
  let(:space1)            { space = FactoryBot.create :space, space_name: 'Space 1',   tenant: tenant
                            space.allowed_time_slots << [morning, brunch, afternoon, evening]
                            space.save
                            space.reload
                          }
  let(:space2)            { space = FactoryBot.create :space, space_name: 'Space 2',   tenant: tenant
                            space.allowed_time_slots << [morning, brunch, afternoon, evening]
                            space.save
                            space.reload
                          }
  let(:start_event)       { event = FactoryBot.create :event, event_name: "Event 1", reason: reason1, tenant: tenant
                            event.event_space_reservations << EventSpaceReservation.create(date: end_last_month,   space: space1, time_slot: brunch)
                            event.event_space_reservations << EventSpaceReservation.create(date: end_last_month,   space: space1, time_slot: evening)
                            event.event_space_reservations << EventSpaceReservation.create(date: start_this_month, space: space1, time_slot: morning)
                            event.event_space_reservations << EventSpaceReservation.create(date: start_this_month, space: space1, time_slot: afternoon)
                            event.event_space_reservations << EventSpaceReservation.create(date: start_this_month, space: space1, time_slot: evening)
                            event.save
                            event.reload
                          }
  let(:middle_event)      { event = FactoryBot.create :event, event_name: "Event 2", reason: reason2, tenant: tenant
                            event.event_space_reservations << EventSpaceReservation.create(date: middle_this_month - 1.day, space: space2, time_slot: evening)
                            event.event_space_reservations << EventSpaceReservation.create(date: middle_this_month,         space: space2, time_slot: evening)
                            event.event_space_reservations << EventSpaceReservation.create(date: middle_this_month + 1.day, space: space2, time_slot: morning)
                            event.event_space_reservations << EventSpaceReservation.create(date: middle_this_month + 1.day, space: space2, time_slot: afternoon)
                            event.event_space_reservations << EventSpaceReservation.create(date: middle_this_month + 1.day, space: space2, time_slot: evening)
                            event.save
                            event.reload
                          }
  let(:end_event)         { event = FactoryBot.create :event, event_name: "Event 3", reason: reason2, tenant: tenant
                            event.event_space_reservations << EventSpaceReservation.create(date: end_this_month,   space: space1, time_slot: brunch)
                            event.event_space_reservations << EventSpaceReservation.create(date: end_this_month,   space: space1, time_slot: evening)
                            event.event_space_reservations << EventSpaceReservation.create(date: start_next_month, space: space1, time_slot: morning)
                            event.event_space_reservations << EventSpaceReservation.create(date: start_next_month, space: space1, time_slot: afternoon)
                            event.event_space_reservations << EventSpaceReservation.create(date: start_next_month, space: space1, time_slot: evening)
                            event.save
                            event.reload
                          }

  describe "GET /tenant/1/spaces" do
    it "shows Demo Group without login" do
      expect(start_event).to      be
      expect(middle_event).to     be
      expect(end_event).to        be

      get tenant_spaces_path(tenant_id: tenant)

      expect(response).to       have_http_status(200)
      expect(response.body).to  match "<p hidden id='tenant_spaces_show_#{tenant.id}' class='pageName'>tenant_spaces_show_#{tenant.id}</p>"

      # navbar present
      expect(response.body).to  match "SharedSpace"

      # shows the DemoGroup (tenant) on the root page
      expect(response.body).to  match "DemoGroup"
      expect(response.body).to  match "Try it out"
      expect(response.body).to  match "Reset every 24 hours"

      # Spaces are present
      expect(response.body).to  match "Space 1"
      expect(response.body).to  match "Space 2"

      # demo shows scheduled events
      expect(response.body.squish).to  match %Q(<div class="calendar-date is-disabled">
                                                  <button data-html="true"
                                                          data-target="edit-reservation-form"
                                                          data-tooltip="Event 1
                                                                        Event 1"
                                                          class="date-item modal-button is-active">
                                                    29
                                                  </button>
                                                </div>).squish
      expect(response.body.squish).to  match %Q(<div class="calendar-date">
                                                  <button data-html="true"
                                                          data-target="edit-reservation-form"
                                                          data-tooltip="Event 2"
                                                          class="date-item modal-button is-active">
                                                    15
                                                  </button>
                                                </div> ).squish

    end
  end

end
