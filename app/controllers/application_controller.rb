class ApplicationController < ActionController::Base

  protected

  def after_sign_in_path_for(resource)
    tenant_path(resource.tenant)
  end

  def after_sign_out_path_for(scope)
    root_path
  end

end
