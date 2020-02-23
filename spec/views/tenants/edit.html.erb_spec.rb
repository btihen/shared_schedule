require 'rails_helper'

RSpec.describe "tenants/edit", type: :view do
  before(:each) do
    @tenant = assign(:tenant, Tenant.create!(
      :tenant_name => "MyString"
    ))
  end

  it "renders the edit tenant form" do
    render

    assert_select "form[action=?][method=?]", tenant_path(@tenant), "post" do

      assert_select "input[name=?]", "tenant[tenant_name]"
    end
  end
end
