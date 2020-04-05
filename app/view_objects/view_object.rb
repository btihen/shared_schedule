# frozen_string_literal: true
require 'csv'

class ViewObject
  include ActiveModel::Model
  include ActiveModel::Serializers::JSON

  attr_reader :view_context, :root_model

  # needed with serializing like when sending an email
  # we must send a stored model to a job (so it can be serialized with the id)
  # to that end, we can't include the view_context for email - thus this is how to include urls in emails
  # https://makandracards.com/makandra/1511-how-to-use-rails-url-helpers-in-any-ruby-class
  delegate :url_helpers, to: 'Rails.application.routes'
  # for nested routes add method directly using:
  # def space_path
  #   url_helpers.tenant_space_path(space_id: space.id, id: id)
  # end
  # for non-nested routes add alias, ie:
  # alias_method :tenant_path, :root_model_path
  def root_model_path
    url_helpers.send("#{root_model.class.name.downcase}_path".to_sym, root_model)
  end
  def root_model_url
    url_helpers.send("#{root_model.class.name.downcase}_url".to_sym, root_model)
  end

  # Models inherits from ` ActiveRecord::Base` which already define the following methods:
  # `to_param` and `model_name` are needed for `link_to`
  # `id` is just important to have for the view to render the model properly
  # `to_partial_path` is required for the view to `render` collections properly
  # figure out how to point to the ROOT_MODEL of the ViewObject instance
  delegate :id, :to_param, :model_name, :to_partial_path, to: :root_model

  def initialize(root_model, view_context=nil)
    @view_context = view_context
    @root_model   = root_model || NoModel.new
  end

  # Initialize collection
  def self.collection(collection, view_context=nil)
    return []   if collection.blank?

    collection.map { |root_model| self.new(root_model, view_context) }
  end

  # export as CSV
  def self.collection_to_csv(view_collection, attribs_list)
    CSV.generate do |csv|
      csv << attribs_list
      view_collection.each do |view_object|
        csv << view_object.root_model.attributes.values_at(*attribs_list)
      end
    end
  end

end
