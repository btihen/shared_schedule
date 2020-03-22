class TenantsController < ApplicationController

  def index
    user          = current_user || GuestUser.new
    user_view     = UserView.new(user)
    tenants       = Tenant.viewable(user_view.tenant)
    # tenants       = Tenant.where(is_publicly_viewable: true)    # public tenants
    #                       .or(Tenant.where(id: user.tenant.id)) # user tenant
    tenant_views  = TenantView.collection(tenants)
    respond_to do |format|
      format.html { render 'tenants/index', locals: {tenants: tenant_views} }
    end
  end

  def show
    user          = current_user || GuestUser.new
    tenant        = Tenant.find(params[:id])
    unauthorized_view(user, tenant); return if performed?

    user_view     = UserView.new(user)
    tenant_view   = TenantView.new(tenant)
    spaces        = Space.viewable(user_view.tenant)
    space_views   = SpaceView.collection(spaces)
    date          = params[:date].nil? ? Date.today : params[:date].to_s.to_date
    calendar_view = CalendarView.new(date: date)

    # spaces        = if user.tenant_id == tenant.id
    #                   tenant.spaces.all
    #                 else
    #                   tenant.spaces.select{ |space| space.is_calendar_public? }
    #                 end

    respond_to do |format|
      format.html { render 'tenants/show', locals: {user: user_view,
                                                    tenant: tenant_view,
                                                    spaces: space_views,
                                                    calendar: calendar_view} }
    end
  end

  # def edit
  # end

  # def update
  #   respond_to do |format|
  #     if @tenant.update(tenant_params)
  #       format.html { redirect_to @tenant, notice: 'Tenant was successfully updated.' }
  #       format.json { render :show, status: :ok, location: @tenant }
  #     else
  #       format.html { render :edit }
  #       format.json { render json: @tenant.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end


  # def new
  #   @tenant = Tenant.new
  # end

  # def create
  #   @tenant = Tenant.new(tenant_params)

  #   respond_to do |format|
  #     if @tenant.save
  #       format.html { redirect_to @tenant, notice: 'Tenant was successfully created.' }
  #       format.json { render :show, status: :created, location: @tenant }
  #     else
  #       format.html { render :new }
  #       format.json { render json: @tenant.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # def destroy
  #   @tenant.destroy
  #   respond_to do |format|
  #     format.html { redirect_to tenants_url, notice: 'Tenant was successfully destroyed.' }
  #     format.json { head :no_content }
  #   end
  # end

  private
    # Only allow a list of trusted parameters through.
    def tenant_params
      params.require(:tenant).permit(:tenant_name)
    end
end
