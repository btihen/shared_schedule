class Planners::UserView < ViewObject

  # alias method allows use to rename view_object to a clear name without the initializer
  alias_method :user,      :root_model
  # alias_method :user_url,  :root_model_url
  # alias_method :user_path, :root_model_path

  # delegate to model for attributes needed
  delegate  :first_name, :last_name, :user_role, :may_edit?, to: :user

  # attribute methods
  def title
    user.user_title || ""
  end

  # view_objects for relationships
  def tenant
    Planners::TenantView.new(user.tenant)
  end

  def interests
    Planners::CategoryView.collection(user.interests)
  end

end
