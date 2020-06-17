require 'rails_helper'

RSpec.describe "ReservationsPath - DemoTenant", type: :request do

  let(:today)             { Date.today }
  # let(:end_last_month)    { today.at_beginning_of_month - 1.day }
  # let(:start_this_month)  { today.at_beginning_of_month }
  # let(:middle_this_month) { today.at_beginning_of_month + 14.days }
  # let(:end_this_month)    { today.at_beginning_of_month.next_month - 1.day }
  # let(:start_next_month)  { today.at_beginning_of_month.next_month }
  let(:tenant)            { FactoryBot.create :tenant, :demo_group }
  let(:category)          { FactoryBot.create :category,  category_name:  'Category',  tenant: tenant }
  let(:event)             { FactoryBot.create :event,     event_name:     'Event',     category: category, tenant: tenant }
  let(:morning)           { FactoryBot.create :time_slot, time_slot_name: 'morning',   begin_time: '08:00', end_time: '12:00', tenant: tenant }
  let(:brunch)            { FactoryBot.create :time_slot, time_slot_name: 'brunch',    begin_time: '10:00', end_time: '14:00', tenant: tenant }
  let(:afternoon)         { FactoryBot.create :time_slot, time_slot_name: 'afternoon', begin_time: '13:00', end_time: '17:00', tenant: tenant }
  let(:evening)           { FactoryBot.create :time_slot, time_slot_name: 'evening',   begin_time: '18:00', end_time: '22:00', tenant: tenant }
  let(:space)             { space = FactoryBot.create :space, space_name: 'Space',     tenant: tenant
                            space.allowed_time_slots << [morning, brunch, afternoon, evening]
                            space.save
                            space.reload }

  describe "POST /spaces/1/reservations/new?date=#{Date.today}" do
    it "create a new reservation for an existing event" do
      # expect(existing_event).to   be
      # expect(existing_space).to   be

      # params = {}

      # post tenant_space_reservations(id_tenant: tenant.id, id: space.id).merge(params)

      get new_space_reservation_path(space_id: space.id), params: {date: Date.today.to_s}
      # get new_tenant_space_reservation_path(tenant_id: tenant.id, space_id: space.id), params: {date: Date.today.to_s}
      # get "/tenants/#{tenant.id}/spaces/#{space.id}/reservations/new?date=#{Date.today}"
      expect(response).to       have_http_status(200)

      # params = {"reservation"=>{"event_id"=>"1", "event_name"=>"", "event_description"=>"", "category_id"=>"", "category_name"=>"", "category_description"=>"", "space_id"=>"1", "host"=>"", "start_date"=>"2020-05-01", "start_time_slot_id"=>"1", "end_date"=>"", "end_time_slot_id"=>"", "is_cancelled"=>"0", "change_notice"=>""}, "commit"=>"Save", "tenant_id"=>"1", "space_id"=>"1"}}
      params = {reservation: {event_id: event.id,
                              event_name: "",
                              event_description: "",
                              category_id: "",
                              category_name: "",
                              category_description: "",
                              space_id: space.id,
                              host: "",
                              start_date: Date.today.to_s,
                              start_time_slot_id: evening.id,
                              end_date: "",
                              end_time_slot_id: "",
                              is_cancelled: "0",
                              change_notice: ""} }

      post space_reservations_path(space_id: space.id), params: params
      # post tenant_space_reservations_path(tenant_id: tenant.id, space_id: space.id), params: params
      # post "/tenants/#{tenant.id}/spaces/#{space.id}/reservations/", params: params
      expect(response).to       have_http_status(302)

      expect(response).to redirect_to(tenant_path(tenant.id))
      follow_redirect!

      expect(response).to       have_http_status(200)
      expect(response.body).to  match "<p hidden id='tenant_show_#{tenant.id}' class='pageName'>"

      # shows the DemoGroup (tenant) on the root page
      expect(response.body).to  match "#{tenant.tenant_name}"

      # Spaces are present
      expect(response.body).to  match "#{space.space_name}"
    end
  end
end
