require 'rails_helper'

RSpec.describe "tenants/index", type: :view do
  before(:each) do
    assign(:tenants, [
      Tenant.create!(
        :tenant_name => "Tenant Name"
      ),
      Tenant.create!(
        :tenant_name => "Tenant Name"
      )
    ])
  end

  it "renders a list of tenants" do
    render
    assert_select "tr>td", :text => "Tenant Name".to_s, :count => 2
  end
end
