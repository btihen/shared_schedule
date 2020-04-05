require 'rails_helper'

RSpec.describe "Spaces index", type: :request do

  let(:tenant)  { FactoryBot.create :tenant }
  let(:reason1) { FactoryBot.create :reason, tenant: tenant }
  let(:reason2) { FactoryBot.create :reason, tenant: tenant }
  let(:time1)   { FactoryBot.create :time_slot, begin_time: '08:00', end_time: '12:00', tenant: tenant }
  let(:time2)   { FactoryBot.create :time_slot, begin_time: '13:00', end_time: '17:00', tenant: tenant }
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
                  event.reservations << Reservation.create(date: Date.today, space: space1, time_slot: time1)
                  event.reservations << Reservation.create(date: Date.today, space: space2, time_slot: time2)
                  event.save
                  event.reload
                }
  let(:event2)  { event = FactoryBot.create :event, reason: reason2, tenant: tenant
                  event.reservations << Reservation.create(date: Date.tomorrow, space: space1, time_slot: time1)
                  event.reservations << Reservation.create(date: Date.yesterday, space: space2, time_slot: time2)
                  event.save
                  event.reload }

  # describe "GET /spaces" do
  #   it "works! (now write some real specs)" do
  #     get tenant_spaces_path(id: space1.id, tenant_id: tenant.id)
  #     expect(response).to have_http_status(200)
  #   end
  # end
end
