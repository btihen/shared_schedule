class ReservationsController < ApplicationController
  def index
    user          = current_user || GuestUser.new
    date          = params[:date].nil? ? Date.today : params[:date].to_s.to_date
    calendar_view = CalendarView.new(date: date)
    tenant        = Tenant.find(params[:tenant_id])
    tenant_view   = TenantView.new(tenant)
    space         = Space.find(params[:space_id])
    # not_auhorized unless tenant.is_publicly_viewable? || tenant.id == user.tenant_id
    # not_auhorized unless space.tenant.id == user.tenant_id
    space_view    = SpaceView.new(space)
    reservations  = Reservation.where(date: date, space_id: space.id)
    reservation_views = ReservationView.collection(reservations)
    respond_to do |format|
      format.html { render 'spaces/index', locals: {tenant: tenant_view,
                                                    space: space_view,
                                                    calendar: calendar_view,
                                                    reservations: reservation_views} }
      json.html   { render :index, status: :ok, reservations: reservation_views }
    end
  end

  def new
    date          = params[:date].nil? ? Date.today : params[:date].to_s.to_date
    calendar_view = CalendarView.new(date: date)
    tenant        = Tenant.find(params[:tenant_id])
    tenant_view   = TenantView.new(tenant)
    space         = Space.find(params[:space_id])
    space_view    = SpaceView.new(space)
    spaces        = tenant.spaces
    space_views   = SpaceView.collection(spaces)
    # not_auhorized unless tenant.is_publicly_viewable? || tenant.id == user.tenant_id
    # not_auhorized unless space.tenant.id == user.tenant_id
    reservation   = Reservation.new(space: space, start_date: date)
    reservation_form = ReservationForm.new_from(reservation)
    respond_to do |format|
      format.html { render 'reservations/new', locals: {space: space_view,
                                                        spaces: space_views,
                                                        tenant: tenant_view,
                                                        reservation: reservation_form} }
      # json.html   { render :index, status: :ok, reservation: reservation_form }
    end
  end

  def create
    attributes       = reservation_params #.merge(sponsor_id: current_user.id)
    reservation_form = ReservationForm.new(attributes)

    date          = params[:date].nil? ? Date.today : params[:date].to_s.to_date
    calendar_view = CalendarView.new(date: date)
    tenant        = Tenant.find(params[:tenant_id])
    tenant_view   = TenantView.new(tenant)
    space         = Space.find(params[:space_id])
    space_view    = SpaceView.new(space)
    spaces        = tenant.spaces
    space_views   = SpaceView.collection(spaces)
    # not_auhorized unless tenant.is_publicly_viewable? || tenant.id == user.tenant_id
    # not_auhorized unless space.tenant.id == user.tenant_id

    if reservation_form.valid?
      reservation = reservation_form.reservation
      reservation.save!

      flash[:notice] = "#{reservation.event.event_name} event was successfully created."
      redirect_to tenant_path(tenant)
    else
      respond_to do |format|
        flash[:alert] = 'Please fix the form errors'
        format.html { render 'reservations/new', locals: {space: space_view,
                                                          spaces: space_views,
                                                          tenant: tenant_view,
                                                          reservation: reservation_form} }
      end
    end
  end

  private
    # Only allow a list of trusted parameters through.
    def reservation_params
      params.require(:reservation)
            .permit(:host, :event_id, :space_id, :start_date, :end_date,
                    :start_time_slot_id, :end_time_slot_id)
    end
end
