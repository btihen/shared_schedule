require 'rails_helper'

RSpec.describe "Managers::Dashboards", type: :request do

  #   let(:today)             { Date.today }
  #   let(:tenant)            { FactoryBot.create :tenant }
  #   let(:category1)         { FactoryBot.create :category, tenant: tenant }
  #   let(:category2)         { FactoryBot.create :category, tenant: tenant }
  #   let(:morning)           { FactoryBot.create :time_slot, time_slot_name: 'morning',   begin_time: '08:00', end_time: '12:00', tenant: tenant }
  #   let(:afternoon)         { FactoryBot.create :time_slot, time_slot_name: 'afternoon', begin_time: '13:00', end_time: '17:00', tenant: tenant }
  #   let(:evening)           { FactoryBot.create :time_slot, time_slot_name: 'evening',   begin_time: '18:00', end_time: '22:00', tenant: tenant }
  #   let(:space1)            { space = FactoryBot.create :space, tenant: tenant
  #                             space.allowed_time_slots << [morning, afternoon]
  #                             space.save
  #                             space.reload
  #                           }
  #   let(:space2)            { space = FactoryBot.create :space, tenant: tenant
  #                             space.allowed_time_slots << [afternoon, evening]
  #                             space.save
  #                             space.reload
  #                           }
  #   let(:event1)            { FactoryBot.create :event, category: category1, tenant: tenant }
  #   let(:event2)            { FactoryBot.create :event, category: category2, tenant: tenant }
  #
  # describe "GET /index" do
  #   context "logged in as a manager" do
  #     # https://github.com/heartcombo/devise/wiki/How-To:-sign-in-and-out-a-user-in-Request-type-specs-(specs-tagged-with-type:-:request)
  #     let(:manager)          { FactoryBot.create :user, :manager }
  #     before do
  #       sign_in manager
  #     end
  #     after do
  #       sign_out manager
  #     end
  #     it "returns http success" do
  #       get "/managers/dashboard/index"
  #       expect(response).to have_http_status(:success)
  #     end
  #   end
  #
  #   context "logged in as a scheduler" do
  #     # https://github.com/heartcombo/devise/wiki/How-To:-sign-in-and-out-a-user-in-Request-type-specs-(specs-tagged-with-type:-:request)
  #     let(:scheduler)              { FactoryBot.create :user, :scheduler }
  #     before do
  #       sign_in scheduler
  #     end
  #     after do
  #       sign_out scheduler
  #     end
  #     it "returns http success" do
  #       # get "/managers/index"
  #       # get "/managers/dashboard/index"
  #       get managers_root_path
  #       expect(response).to have_http_status(:success)
  #     end
  #   end
  #
  #   context "not logged - evil guest" do
  #     it "returns http success" do
  #       # get "/managers/index"
  #       # get "/managers/dashboard/index"
  #       get managers_root_path
  #       expect(response).to have_http_status(:success)
  #     end
  #   end
  #
  # end

end
