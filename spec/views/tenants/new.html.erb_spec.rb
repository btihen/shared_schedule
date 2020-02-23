require 'rails_helper'

RSpec.describe "tenants/new", type: :view do
  before(:each) do
    assign(:tenant, Tenant.new(
      :tenant_name => "MyString"
    ))
  end

  it "renders new tenant form" do
    render

    assert_select "form[action=?][method=?]", tenants_path, "post" do

      assert_select "input[name=?]", "tenant[tenant_name]"
    end
  end
end
