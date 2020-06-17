class Managers::AppController < ApplicationController

  before_action :authenticate_user!

  def unauthorized_manager_view(user, tenant, space=nil, reservation=nil)
    return if user.user_role == 'manager' && tenant.spaces.include?(space) && tenant.reservations.include?(reservation)
    return if user.user_role == 'manager' && tenant.spaces.include?(space)
    return if user.user_role == 'manager'

    respond_to do |format|
      flash[:alert] = 'Unauthorized'
      format.html { redirect_to root_path }
    end
  end

  def unauthorized_manager_change(user, tenant, space=nil, reservation=nil)
    return if user.user_role == 'manager' && tenant.spaces.include?(space) && tenant.reservations.include?(reservation)
    return if user.user_role == 'manager' && tenant.spaces.include?(space)
    return if user.user_role == 'manager'

    respond_to do |format|
      flash[:alert] = 'Unauthorized'
      format.html { redirect_to root_path }
    end
  end

end
