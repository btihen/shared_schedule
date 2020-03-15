class ReasonView < ViewObject 

  # alias method allows use to rename view_object to a clear name without the initializer
  alias_method :reason,      :root_model
  alias_method :reason_url,  :root_model_url
  alias_method :reason_path, :root_model_path

  # delegate to model for attributes needed
  delegate  :reason_name, to: :reason

  def reason_description
    reason.reason_description || ""
  end

  # view_objects for relationships
  def tenant
    TenantView.new(reason.tenant)
  end

  # needed?
  # def interested_users
  #   UserView.collection(reason.users)
  # end

end
