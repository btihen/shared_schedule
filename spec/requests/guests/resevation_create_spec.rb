require 'rails_helper'
# support for: .at_beginning_of_month & .next_month
require 'active_support'

RSpec.describe "Reservation Create", type: :request do

  let(:today)             { Date.today }
  # let(:end_last_month)    { today.at_beginning_of_month - 1.day }
  # let(:start_this_month)  { today.at_beginning_of_month }
  # let(:middle_this_month) { today.at_beginning_of_month + 15.days }
  # let(:end_this_month)    { today.at_beginning_of_month.next_month - 1.day }
  # let(:start_next_month)  { today.at_beginning_of_month.next_month }
  let(:tenant)            { FactoryBot.create :tenant }
  let(:category1)         { FactoryBot.create :category, tenant: tenant }
  let(:category2)         { FactoryBot.create :category, tenant: tenant }
  let(:morning)           { FactoryBot.create :time_slot, time_slot_name: 'morning',   begin_time: '08:00', end_time: '12:00', tenant: tenant }
  let(:brunch)            { FactoryBot.create :time_slot, time_slot_name: 'brunch',    begin_time: '10:00', end_time: '14:00', tenant: tenant }
  let(:afternoon)         { FactoryBot.create :time_slot, time_slot_name: 'afternoon', begin_time: '13:00', end_time: '17:00', tenant: tenant }
  let(:evening)           { FactoryBot.create :time_slot, time_slot_name: 'evening',   begin_time: '18:00', end_time: '22:00', tenant: tenant }
  let(:space)             { space = FactoryBot.create :space, tenant: tenant
                            space.allowed_time_slots << [morning, brunch, afternoon, evening]
                            space.save
                            space.reload
                          }
  let(:existing_event)    { FactoryBot.create :event, category: category1, tenant: tenant }

  describe "GET space/space_id/reservations/new" do
    it "New reservation - with an existing event" do
      get new_space_reservation_path(space_id: space.id), params: {date: Date.today.to_s}
      expect(response).to have_http_status(302)
      follow_redirect!
      expect(response).to have_http_status(200)
    end
    # it "CREATE reservation with an existing event" do
    #   post tenant_space_reservation_path(space_id: space.id), params: {date: calendar.display_date(day)}
    # end
    # it "CREATE reservation with a new event" do
    #   post tenant_space_reservation_path(space_id: space.id), params: {date: calendar.display_date(day)}
    # end
  end
end
