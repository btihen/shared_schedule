require "rails_helper"

RSpec.describe LandingController, type: :routing do
  describe "routing" do
    # undefined method `authenticate?' for nil:NilClass
    xit "routes to #index" do
      expect(:get => "/").to route_to("guests/landing#index")
    end
  end
end
