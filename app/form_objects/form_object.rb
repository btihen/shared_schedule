# frozen_string_literal: true

# https://ducktypelabs.com/how-to-keep-your-controllers-thin-with-form-objects/
# # sample generic InputForm
class FormObject

  attr_reader :root_model

  # ActiveModel provides validations & form_for tools
  include ActiveModel::Model
  include ActiveModel::Dirty
  include ActiveModel::Attributes
  # include ActiveSupport::Callbacks  # discouraged using callbacks!

  # if model is backed by the db delgation can be useful - (best in most cases)
  # delegate :id, :persisted?,  to: :root_model,  allow_nil: true
  # attr_accessor :id

  # def initialize(root_model)
  #   @root_model   = root_model
  # end

  # The Rails form builder methods (form_for and the rest) need model_name to be defined.
  # def self.model_name
  #   ActiveModel::Name.new(self, nil, root_model.class.name)
  # end

  # when the model will never already stored then use the following:
  # def persisted?
  #   return true  if id.present?
  #   return false # if id.blank?
  # end

#   # All the models that are apart of our form should be part attr_accessor.
#   # This allows the form to be initialized with existing instances.
#   attr_accessor :contact, :attendee, :initiative, :attendee_school
#
#   # list attributes used in the form
#   attr_accessor :model_id
#
#   # define attributes for input conversion
#   attribute :model_id,       Integer
#
#   # add necessary validations
#   validates :model_id,       presence: true
#
end
