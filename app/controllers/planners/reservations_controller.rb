class Planners::ReservationsController < Planners::AppController

  def index
    user          = current_user || GuestUser.new
    space         = Space.find(params[:space_id])
    tenant        = space.tenant
    unauthorized_view(user, tenant, space); return if performed?

    date          = params[:date].nil? ? Date.today : params[:date].to_s.to_date
    tenant_view   = TenantView.new(tenant)
    space_view    = SpaceView.new(space)
    reservations  = Reservation.where(space_id: space.id)
                              .where('start_date <= :date AND end_date >= :date', date: date)
    reservation_views = ReservationView.collection(reservations)
    user_view     = UserView.new(user)
    calendar_view = CalendarView.new(tenant_view, user_view, date)

    respond_to do |format|
      format.html { render 'planners/spaces/show', locals: { user: user_view,
                                                    tenant: tenant_view,
                                                    space: space_view,
                                                    calendar: calendar_view,
                                                    reservations: reservation_views} }
      format.json { render :index, status: :ok, reservations: reservation_views }
    end
  end

  def new
    user          = current_user || GuestUser.new
    space         = Space.find(params[:space_id])
    tenant        = space.tenant
    unauthorized_change(user, tenant, space); return if performed?

    date          = params[:date].nil? ? Date.today : params[:date].to_s.to_date
    tenant_view   = TenantView.new(tenant)
    space_view    = SpaceView.new(space)
    user_view     = UserView.new(user)

    reservation   = Reservation.new(space: space, start_date: date)
    reservation_form = ReservationForm.new_from(reservation)
    respond_to do |format|
      format.html { render 'planners/reservations/new', locals: {user: user_view,
                                                        space: space_view,
                                                        tenant: tenant_view,
                                                        reservation: reservation_form} }
      # format.json { render :index, status: :ok, reservation: reservation_form }
    end
  end

  def create
    user          = current_user || GuestUser.new
    space         = Space.find(params[:space_id])
    tenant        = space.tenant
    unauthorized_change(user, tenant, space); return if performed?

    tenant_view   = TenantView.new(tenant)
    space_view    = SpaceView.new(space)
    user_view     = UserView.new(user)

    reservation_form = ReservationForm.new(reservation_params)
    if reservation_form.valid?
      reservation = reservation_form.reservation
      reservation.save!

      flash[:notice] = "#{reservation.event.event_name} event was successfully reserved."
      redirect_to tenant_path(tenant)
    else
      respond_to do |format|
        flash[:alert] = 'Please fix the errors'
        format.html { render 'planners/reservations/new',
                              locals: { user: user_view,
                                        space: space_view,
                                        tenant: tenant_view,
                                        reservation: reservation_form } }
      end
    end
  end

  def edit
    user          = current_user || GuestUser.new
    space         = Space.find(params[:space_id])
    tenant        = space.tenant
    reservation   = Reservation.find(params[:id])
    unauthorized_change(user, tenant, space, reservation); return if performed?

    reservation_form = ReservationForm.new_from(reservation)
    tenant_view   = TenantView.new(tenant)
    space_view    = SpaceView.new(space)
    user_view     = UserView.new(user)

    respond_to do |format|
      format.html { render 'planners/reservations/edit',
                            locals: { user: user_view,
                                      space: space_view,
                                      tenant: tenant_view,
                                      reservation: reservation_form } }
      # format.json { render :index, status: :ok, reservation: reservation_form }
    end
  end

  def update
    user          = current_user || GuestUser.new
    space         = Space.find(params[:space_id])
    tenant        = space.tenant

    udpated_attrs = reservation_params.merge(id: params[:id])
    reservation_form = ReservationForm.new(udpated_attrs)
    unauthorized_change(user, tenant, space, reservation_form.reservation); return if performed?

    tenant_view   = TenantView.new(tenant)
    space_view    = SpaceView.new(space)
    user_view     = UserView.new(user)

    if reservation_form.valid?
      reservation = reservation_form.reservation
      reservation.save!

      flash[:notice] = "#{reservation.event.event_name} event was successfully updated."
      redirect_to tenant_path(tenant)
    else
      respond_to do |format|
        flash[:alert] = 'Please fix the errors'
        format.html { render 'planners/reservations/edit',
                              locals: { user: user_view,
                                        space: space_view,
                                        tenant: tenant_view,
                                        reservation: reservation_form} }
      end
    end
  end

  private
    # Only allow a list of trusted parameters through.
    def reservation_params
      params.require(:reservation)
            .permit(:host, :space_id, :event_id, :category_id, :start_date, :end_date,
                    :is_cancelled, :change_notice, :start_time_slot_id, :end_time_slot_id,
                    :event_name, :event_description, :category_name, :category_description)
    end
end
