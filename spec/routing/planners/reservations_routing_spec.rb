require "rails_helper"

RSpec.describe Planners::TenantsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/planners/spaces/1/reservations").to route_to("planners/reservations#index", :space_id => "1")
    end

    it "routes to #new" do
      expect(:get => "/planners/spaces/1/reservations/new").to route_to("planners/reservations#new", :space_id => "1")
    end

    # it "routes to #show" do
    #   expect(:get => "/planners/spaces/1/reservations/1").to route_to("planners/reservations#show", :space_id => "1", :id => "1")
    # end

    it "routes to #edit" do
      expect(:get => "/planners/spaces/1/reservations/1/edit").to route_to("planners/reservations#edit", :space_id => "1", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/planners/spaces/1/reservations").to route_to("planners/reservations#create", :space_id => "1")
    end

    it "routes to #update via PUT" do
      expect(:put => "/planners/spaces/1/reservations/1").to route_to("planners/reservations#update", :space_id => "1", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/planners/spaces/1/reservations/1").to route_to("planners/reservations#update", :space_id => "1", :id => "1")
    end

    # it "routes to #destroy" do
    #   expect(:delete => "/planners/spaces/1/reservations/1").to route_to("planners/reservations#destroy", :space_id => "1", :id => "1")
    # end
  end
end
