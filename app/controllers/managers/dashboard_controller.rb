class Managers::DashboardController < Managers::AppController

  def index
    user          = current_user
    tenant        = current_user.tenant

    tenant_view   = Managers::TenantView.new(tenant)

    unauthorized_manager_view(user, tenant); return if performed?

    respond_to do |format|
      format.html { render 'managers/dashboard/index',
                            locals: { tenant_view: tenant_view } }
    end
  end

end
