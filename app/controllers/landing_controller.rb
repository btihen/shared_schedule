class LandingController < ApplicationController

  def index
    date          = params[:date].nil? ? Date.today : params[:date].to_s.to_date
    calendar_view = CalendarView.new(date: date)
    tenant        = Tenant.find_by(tenant_name: "DemoGroup")
    tenant_view   = TenantView.new(tenant)
    spaces_view   = tenant_view.spaces
    respond_to do |format|
      format.html { render 'landing/index',
                    locals: { spaces: spaces_view,
                              tenant: tenant_view,
                              calendar: calendar_view }
                  }
    end
  end

end
