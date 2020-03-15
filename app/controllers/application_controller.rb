class ApplicationController < ActionController::Base

  # before_action :authenticate_user_or_guest

  protected

    # redirect on sign-in (see page for after signup details too)
    # https://github.com/heartcombo/devise/wiki/How-To:-Redirect-to-a-specific-page-on-successful-sign-in,-sign-up,-or-sign-out
    def after_sign_in_path_for(resource)
      tenant_path(resource.tenant)
    end

    def after_sign_out_path_for(scope)
      root_path
    end

  private
    def unauthorized_view(user, tenant, space=nil)
      return if space.blank? &&
                ( tenant.is_demo? || tenant.is_publicly_viewable? ||
                  user.tenant.id == tenant.id )

      return if space.present? && tenant.spaces.include?(space) &&
                ( tenant.is_demo? || tenant.is_publicly_viewable? ||
                  user.tenant.id == tenant.id )

      respond_to do |format|
        flash[:alert] = 'Unauthorized'
        format.html { redirect_to root_path }
      end
    end

    def unauthorized_change(user, tenant, space=nil)
      return if space.blank? &&
                ( tenant.is_demo? ||
                  ((user.tenant.id == tenant.id) && user.may_edit?) )

      return if space.present? && tenant.spaces.include?(space) &&
                ( tenant.is_demo? ||
                  ((user.tenant.id == tenant.id) && user.may_edit?) )

      respond_to do |format|
        flash[:alert] = 'Unauthorized'
        format.html { redirect_to root_path }
      end
    end

    # def authenticate_user_or_guest
    #   if user_signed_in? # && current_user != GuestUser.new
    #     authenticate_user!
    #   else
    #     current_user = GuestUser.new
    #   end
    # end

end
