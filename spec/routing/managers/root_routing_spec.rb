require "rails_helper"

RSpec.describe Managers::DashboardController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/managers").to route_to("managers/dashboard#index")
    end
  end
end
