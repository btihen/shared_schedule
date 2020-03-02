class LandingController < ApplicationController

  def index
    date          = params[:date].nil? ? Date.today : params[:date].to_s.to_date
    calendar_view = CalendarView.new(date: date)
    tenant        = Tenant.find_by(tenant_name: "DemoGroup")
    tenant_view   = TenantView.new(tenant)
    spaces        = tenant.spaces.all
    space_views   = SpaceView.collection(spaces)
    respond_to do |format|
      format.html { render 'landing/index',
                    locals: { spaces: space_views,
                              tenant: tenant_view,
                              calendar: calendar_view }
                  }
    end
  end

end
