class LandingController < ApplicationController

  def index
    tenant      = Tenant.find_by(tenant_name: "DemoGroup")
    tenant_view = TenantView.new(tenant)
    spaces      = tenant.spaces.all
    space_views = SpaceView.collection(spaces)
    respond_to do |format|
      format.html { render 'landing/index', locals: {spaces: space_views, tenant: tenant_view} }
    end
  end

end
