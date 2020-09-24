require "rails_helper"

RSpec.describe Planners::TenantsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      # expect(:get => "/planners").to route_to("planners/home#index")
      expect(:get => "/planners").to route_to("planners/tenants#index")
    end

    # it "routes to #new" do
    #   expect(:get => "/planners/tenants/new").to route_to("planners/tenants#new")
    # end

    # it "routes to #show" do
    #   expect(:get => "/planners/tenants/1").to route_to("planners/tenants#show", :id => "1")
    # end

    # it "routes to #edit" do
    #   expect(:get => "/planners/tenants/1/edit").to route_to("planners/tenants#edit", :id => "1")
    # end
    #
    # it "routes to #create" do
    #   expect(:post => "/planners/tenants").to route_to("planners/tenants#create")
    # end
    #
    # it "routes to #update via PUT" do
    #   expect(:put => "/planners/tenants/1").to route_to("planners/tenants#update", :id => "1")
    # end
    #
    # it "routes to #update via PATCH" do
    #   expect(:patch => "/planners/tenants/1").to route_to("planners/tenants#update", :id => "1")
    # end
    #
    # it "routes to #destroy" do
    #   expect(:delete => "/planners/tenants/1").to route_to("planners/tenants#destroy", :id => "1")
    # end
  end
end
