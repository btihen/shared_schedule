class Planners::AppController < ApplicationController

  before_action :authenticate_user!

  private

  def unauthorized_planner_view(user, tenant, space=nil, reservation=nil)
    return if tenant.users.include?(user) && tenant.spaces.include?(space) &&
              tenant.reservations.include?(reservation)
    return if tenant.users.include?(user) && tenant.spaces.include?(space) &&
              reservation.nil?
    return if tenant.users.include?(user) && spaces.nil? && reservation.nil?

    respond_to do |format|
      flash[:alert] = 'Unauthorized'
      format.html { redirect_to planner_root_path }
    end
  end

  def unauthorized_planner_change(user, tenant, space=nil, reservation=nil)
    return if tenant.users.include?(user) && tenant.spaces.include?(space) &&
              tenant.reservations.include?(reservation) && user.may_edit?
    return if tenant.users.include?(user) && tenant.spaces.include?(space) &&
              reservation.nil? && user.may_edit?
    return if tenant.users.include?(user) && spaces.nil? &&
              reservation.nil? && user.may_edit?

    respond_to do |format|
      flash[:alert] = 'Unauthorized'
      format.html { redirect_to planner_root_path }
    end
  end

end
