require "rails_helper"

RSpec.describe SpacesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/tenants/1/spaces").to route_to("spaces#index", :tenant_id => "1")
    end

    # it "routes to #new" do
    #   expect(:get => "/tenants/1/spaces/new").to route_to("spaces#new")
    # end

    it "routes to #show" do
      expect(:get => "/tenants/1/spaces/1").to route_to("spaces#show", :tenant_id => "1", :id => "1")
    end

    # it "routes to #edit" do
    #   expect(:get => "/tenants/1/spaces/1/edit").to route_to("spaces#edit", :id => "1")
    # end

    # it "routes to #create" do
    #   expect(:post => "/tenants/1/spaces/").to route_to("spaces#create")
    # end

    # it "routes to #update via PUT" do
    #   expect(:put => "/tenants/1/spaces/1").to route_to("spaces#update", :id => "1")
    # end

    # it "routes to #update via PATCH" do
    #   expect(:patch => "/tenants/1/spaces/1").to route_to("spaces#update", :id => "1")
    # end

    # it "routes to #destroy" do
    #   expect(:delete => "/tenants/1/spaces/1").to route_to("spaces#destroy", :id => "1")
    # end
  end
end
