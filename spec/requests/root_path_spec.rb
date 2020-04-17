require 'rails_helper'

RSpec.describe "RootPath", type: :request do

  let(:today)             { Date.today }
  let(:end_last_month)    { today.at_beginning_of_month - 1.day }
  let(:start_this_month)  { today.at_beginning_of_month }
  let(:middle_this_month) { today.at_beginning_of_month + 14.days }
  let(:end_this_month)    { today.at_beginning_of_month.next_month - 1.day }
  let(:start_next_month)  { today.at_beginning_of_month.next_month }
  let(:tenant)            { FactoryBot.create :tenant, :demo_group,
                                                tenant_name: "Shared Schedules",
                                                tenant_description: "Where groups come to share their space and schedule and keep informed."}
  let(:reason1)           { FactoryBot.create :reason, tenant: tenant }
  let(:reason2)           { FactoryBot.create :reason, tenant: tenant }
  let(:morning)           { FactoryBot.create :time_slot, time_slot_name: 'morning',   begin_time: '08:00', end_time: '12:00', tenant: tenant }
  let(:brunch)            { FactoryBot.create :time_slot, time_slot_name: 'brunch',    begin_time: '10:00', end_time: '14:00', tenant: tenant }
  let(:afternoon)         { FactoryBot.create :time_slot, time_slot_name: 'afternoon', begin_time: '13:00', end_time: '17:00', tenant: tenant }
  let(:evening)           { FactoryBot.create :time_slot, time_slot_name: 'evening',   begin_time: '18:00', end_time: '22:00', tenant: tenant }
  let(:space1)            { space = FactoryBot.create :space, space_name: 'Space 1',   tenant: tenant
                            space.allowed_time_slots << [morning, brunch, afternoon, evening]
                            space.save
                            space.reload }
  let(:space2)            { space = FactoryBot.create :space, space_name: 'Space 2',   tenant: tenant
                            space.allowed_time_slots << [morning, brunch, afternoon, evening]
                            space.save
                            space.reload }
  let(:start_event)       { event = FactoryBot.create :event, event_name: "Event 1", reason: reason1, tenant: tenant
                            event.reservations << Reservation.create(space: space1, start_date: end_last_month,   start_time_slot: brunch,    end_date: end_last_month,   end_time_slot: brunch)
                            event.reservations << Reservation.create(space: space1, start_date: end_last_month,   start_time_slot: evening,   end_date: end_last_month,   end_time_slot: evening)
                            event.reservations << Reservation.create(space: space1, start_date: start_this_month, start_time_slot: morning,   end_date: start_this_month, end_time_slot: morning)
                            event.reservations << Reservation.create(space: space1, start_date: start_this_month, start_time_slot: afternoon, end_date: start_this_month, end_time_slot: afternoon)
                            event.reservations << Reservation.create(space: space1, start_date: start_this_month, start_time_slot: evening,   end_date: start_this_month, end_time_slot: evening)
                            event.save
                            event.reload }
  let(:middle_event)      { event = FactoryBot.create :event, event_name: "Event 2", reason: reason2, tenant: tenant
                            event.reservations << Reservation.create(space: space2, start_date: middle_this_month - 1.day, start_time_slot: evening,   end_date: middle_this_month - 1.day, end_time_slot: evening)
                            event.reservations << Reservation.create(space: space2, start_date: middle_this_month,         start_time_slot: evening,   end_date: middle_this_month,         end_time_slot: evening)
                            event.reservations << Reservation.create(space: space2, start_date: middle_this_month + 1.day, start_time_slot: morning,   end_date: middle_this_month + 1.day, end_time_slot: morning)
                            event.reservations << Reservation.create(space: space2, start_date: middle_this_month + 1.day, start_time_slot: afternoon, end_date: middle_this_month + 1.day, end_time_slot: afternoon)
                            event.reservations << Reservation.create(space: space2, start_date: middle_this_month + 1.day, start_time_slot: evening,   end_date: middle_this_month + 1.day, end_time_slot: evening)
                            event.save
                            event.reload }
  let(:end_event)         { event = FactoryBot.create :event, event_name: "Event 3", reason: reason2, tenant: tenant
                            event.reservations << Reservation.create(space: space1, start_date: end_this_month,   start_time_slot: brunch,    end_date: end_this_month,   end_time_slot: brunch)
                            event.reservations << Reservation.create(space: space1, start_date: end_this_month,   start_time_slot: evening,   end_date: end_this_month,   end_time_slot: evening)
                            event.reservations << Reservation.create(space: space1, start_date: start_next_month, start_time_slot: morning,   end_date: start_next_month, end_time_slot: morning)
                            event.reservations << Reservation.create(space: space1, start_date: start_next_month, start_time_slot: afternoon, end_date: start_next_month, end_time_slot: afternoon)
                            event.reservations << Reservation.create(space: space1, start_date: start_next_month, start_time_slot: evening,   end_date: start_next_month, end_time_slot: evening)
                            event.save
                            event.reload }
  describe "GET /" do
    it "shows landing page without DemoGroup" do
      get root_path

      expect(response).to           have_http_status(200)
      expect(response.body).to      match "<p hidden id='landing_index' class='pageName'>Landing Index</p>"

      # navbar present
      expect(response.body).to      match "Shared Schedules"

      # The hero section on webpage
      expect(response.body).to      match "Shared Schedules"
      expect(response.body).to      match "Where groups come to share their space and schedule and keep informed."

      # shows the DemoGroup (tenant) on the root page
      expect(response.body).to      match "#{tenant.tenant_name}"
    end
    it "shows Demo Group without login" do
      expect(start_event).to      be
      expect(middle_event).to     be
      expect(end_event).to        be

      get root_path

      expect(response).to         have_http_status(200)
      expect(response.body).to    match "<p hidden id='landing_index' class='pageName'>Landing Index</p>"

      # navbar present
      expect(response.body).to    match "Shared Schedules"

      # The hero section on webpage
      expect(response.body).to    match "Shared Schedules"
      expect(response.body).to    match "Where groups come to share their space and schedule and keep informed."

      # shows the DemoGroup (tenant) on the root page
      expect(response.body).to    match "#{tenant.tenant_name}"
      expect(response.body).to    match "#{tenant.tenant_tagline}"
      expect(response.body).to    match "#{tenant.tenant_description}"

      # Spaces are present
      expect(response.body).to    match "#{space1.space_name}"
      expect(response.body).to    match "#{space2.space_name}"
# move to a feature test
# pp response.body
#       # first calendar scheduled events (from previous month - disabled)
#       # expect(response.body.squish).to  match %Q(<div class="calendar-date is-disabled">
#       #                                             <button data-html="true"
#       #                                                     data-href="/tenant/2/space/3/reservations?date=2020-12-20"
#       #                                                     data-target="reservation-details"
#       #                                                     data-tooltip="#{start_event.event_name}
#       #                                                                   #{start_event.event_name}"
#       #                                                     class="date-item modal-button is-active">
#       #                                               #{end_last_month.mday}
#       #                                             </button>
#       #                                           </div>).squish

#       # calendar button for days without an event
#       expect(response.body.squish).to  match %Q(<div class="calendar-date">
#             <button data-html="true"
#                     data-href="\/tenant\/2\/space\/3\/reservations\?date\=2020\-12\-20"
#                     data-target="reservation-new"
#                     data-tooltip=""
#                     class="date-item modal-button">
#               10
#             </button>
#           </div>).squish
#       # expect(response.body.squish).to  match %Q(<div class="calendar-date">
#       #                                             <button data-html="true"
#       #                                                     data-href="/tenant/2/space/3/reservations?date=2020-12-20"
#       #                                                     data-target="reservation-new"
#       #                                                     data-tooltip=""
#       #                                                     class="date-item modal-button">
#       #                                               10
#       #                                             </button>
#       #                                           </div>).squish

#       # second calendar shows scheduled events that are viewable (active)
#       expect(response.body.squish).to  match %Q(<div class="calendar-date">
#                                                   <button data-html="true"
#                                                           data-href="\/tenant\/2\/space\/3\/reservations\?date=2020-12-20"
#                                                           data-target="reservation-details"
#                                                           data-tooltip="#{middle_event.event_name}"
#                                                           class="date-item modal-button is-active">
#                                                     #{middle_this_month.mday}
#                                                   </button>
#                                                 </div>).squish
    end
  end
end
