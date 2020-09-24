class Planners::CategoryView < ViewObject

  # alias method allows use to rename view_object to a clear name without the initializer
  alias_method :category,      :root_model
  # alias_method :category_url,  :root_model_url
  # alias_method :category_path, :root_model_path

  # delegate to model for attributes needed
  delegate  :category_name, to: :category

  def category_description
    category.category_description || ""
  end

  # view_objects for relationships
  def tenant
    Planners::TenantView.new(category.tenant)
  end

  # needed?
  # def interested_users
  #   UserView.collection(category.users)
  # end

end
