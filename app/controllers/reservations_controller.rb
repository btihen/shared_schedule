class ReservationsController < ApplicationController
  def index
    date          = params[:date].nil? ? Date.today : params[:date].to_s.to_date
    calendar_view = CalendarView.new(date: date)
    tenant        = Tenant.find(params[:tenant_id])  # replace with user_id ASAP
    tenant_view   = TenantView.new(tenant)
    space         = Space.find(params[:space_id])
    space_view    = SpaceView.new(space)
    reservations  = Reservation.where(date: date, space_id: space.id)
    reservation_views = ReservationView.collection(reservations)
    respond_to do |format|
      format.html { render 'spaces/index', locals: {tenant: tenant_view,
                                                    spaces: space_view,
                                                    calendar: calendar_view
                                                    reservations: reservation_views} }
      json.html   { render :index, status: :ok, reservations: reservation_views }
    end
  end
end
