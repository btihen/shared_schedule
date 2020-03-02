class TenantsController < ApplicationController

  def index
    tenants      = Tenant.all
    tenant_views = TenantView.collection(tenants)
    respond_to do |format|
      format.html { render 'tenants/index', locals: {tenants: tenant_views} }
    end
  end

  def show
    date          = params[:date].nil? ? Date.today : params[:date].to_s.to_date
    calendar_view = CalendarView.new(date: date)
    tenant        = Tenant.find(params[:id])
    tenant_view   = TenantView.new(tenant)
    spaces        = tenant.spaces.all
    space_views   = SpaceView.collection(spaces)
    respond_to do |format|
      format.html { render 'tenants/show',
                    locals: { tenant: tenant,
                              spaces: space_views,
                              calendar: calendar_view }
                  }
    end
  end

  def new
    @tenant = Tenant.new
  end

  def edit
  end

  def create
    @tenant = Tenant.new(tenant_params)

    respond_to do |format|
      if @tenant.save
        format.html { redirect_to @tenant, notice: 'Tenant was successfully created.' }
        format.json { render :show, status: :created, location: @tenant }
      else
        format.html { render :new }
        format.json { render json: @tenant.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @tenant.update(tenant_params)
        format.html { redirect_to @tenant, notice: 'Tenant was successfully updated.' }
        format.json { render :show, status: :ok, location: @tenant }
      else
        format.html { render :edit }
        format.json { render json: @tenant.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @tenant.destroy
    respond_to do |format|
      format.html { redirect_to tenants_url, notice: 'Tenant was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Only allow a list of trusted parameters through.
    def tenant_params
      params.require(:tenant).permit(:tenant_name)
    end
end
