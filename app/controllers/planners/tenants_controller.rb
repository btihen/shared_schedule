class Planners::TenantsController < Planners::AppController

  def index
    user          = current_user || GuestUser.new
    user_view     = UserView.new(user)
    tenants       = Tenant.viewable_by(user) || user.tenant
    tenants_views = TenantView.collection(tenants)
    respond_to do |format|
      format.html { render 'planners/tenants/index',
                            locals: {tenants_view: tenants_views} }
    end
  end

  def show
    user          = current_user || GuestUser.new
    tenant        = Tenant.find(params[:id])
    unauthorized_view(user, tenant); return if performed?

    user_view     = UserView.new(user)
    tenant_view   = TenantView.new(tenant)
    spaces        = Space.viewable_by(user, tenant)
    space_views   = SpaceView.collection(spaces)
    date          = params[:date].nil? ? Date.today : params[:date].to_s.to_date
    calendar_view = CalendarView.new(tenant_view, user_view, date)

    respond_to do |format|
      format.html { render 'planners/tenants/show',
                            locals: { user_view: user_view,
                                      tenant_view: tenant_view,
                                      spaces_view: space_views,
                                      calendar_view: calendar_view } }
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
