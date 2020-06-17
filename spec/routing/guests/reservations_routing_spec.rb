require "rails_helper"

RSpec.describe Guests::ReservationsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/spaces/1/reservations").to route_to("guests/reservations#index", :space_id => "1")
    end

    it "routes to #new" do
      expect(:get => "/spaces/1/reservations/new").to route_to("guests/reservations#new", :space_id => "1")
    end

    # it "routes to #show" do
    #   expect(:get => "/tenants/1").to route_to("guests/reservations#show", :space_id => "1", :id => "1")
    # end

    it "routes to #edit" do
      expect(:get => "/spaces/1/reservations/1/edit").to route_to("guests/reservations#edit", :space_id => "1", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/spaces/1/reservations").to route_to("guests/reservations#create", :space_id => "1")
    end

    it "routes to #update via PUT" do
      expect(:put => "/spaces/1/reservations/1").to route_to("guests/reservations#update", :space_id => "1", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/spaces/1/reservations/1").to route_to("guests/reservations#update", :space_id => "1", :id => "1")
    end

    # it "routes to #destroy" do
    #   expect(:delete => "/spaces/1/reservations/1").to route_to("guests/reservations#destroy", :space_id => "1", :id => "1")
    # end
  end
end
