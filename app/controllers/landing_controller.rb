class LandingController < ApplicationController

  # skip_before_action :authenticate_user!, raise: false
  #
  # def index
  #   user          = current_user || GuestUser.new
  #   date          = params[:date].nil? ? Date.today : params[:date].to_s.to_date
  #   tenant        = Tenant.landing_page(user) || user.tenant
  #   tenant_view   = TenantView.new(tenant)
  #
  #   spaces        = Space.unscoped.viewable_by(user, tenant)
  #   spaces_view   = SpaceView.collection(spaces)
  #   user_view     = UserView.new(user)
  #   calendar_view = CalendarView.new(tenant_view, user_view, date)
  #
  #   respond_to do |format|
  #     format.html { render 'landing/index',
  #                           locals: { user_view: user_view,
  #                                     spaces_view: spaces_view,
  #                                     tenant_view: tenant_view,
  #                                     calendar_view: calendar_view } }
  #   end
  # end

end
