# frozen_string_literal: true

# https://ducktypelabs.com/how-to-keep-your-controllers-thin-with-form-objects/
# # sample generic InputForm
class FormModel

  attr_accessor :root_model
  attr_reader   :root_attributes

  # ActiveModel provides validations & form_for tools ( name introspection & conversions) & translations
  include ActiveModel::Model
  include ActiveModel::Dirty
  include ActiveModel::Attributes
  # include ActiveSupport::Callbacks  # discouraged using callbacks!
  # include ActiveModel::Serializers::JSON

  # if model is backed by the db delgation can be useful - (best in most cases)
  delegate :id, :persisted?,  to: :root_model,  allow_nil: true
  attr_accessor :id

  # when the model will never already stored then use the following:
  # def persisted?
  #   return true  if id.present?
  #   return false # if id.blank?
  # end
  # The Rails form builder methods (form_for and the rest) need model_name to be defined.
  # def self.model_name
  #   ActiveModel::Name.new(self, nil, root_model.class.name)
  # end

  validate :root_model_validation

  # def initialize(attribs)
  #   super
  #   @root_model   = self
  # end

  def root_class
    raise NotImplementedError
  end

  def root_model
    @root_model ||= root_class.find_by(id: id) || root_class.new
  end

  private

  def root_attributes
    @root_attributes ||= instance_values["attributes"].send(:attributes).map{ |attr, _val| attr.to_sym }
  end

  # seems dangerous with mixed models
#   def assign_root_attribs
# binding.pry
#     # get / create instance
#     root_model      = root_class.find_by(id: id) || root_class.new
#     # assign incomming attributes to model
#     root_attributes = instance_values["attributes"].send(:attributes).map{ |attr, _val| attr }
#     # assign attributes to root model
#     root_attributes.each do |attrib|
#       attrib_sym = attrib.to_sym
#       root_model.send(attrib_sym) = attributes[attrib]
#     end
#     root_model
#   end

  def root_model_validation
    return if root_model.valid?

    # copy root_model validation errors into form errors hash to display in the view
    root_model.errors.each do |attribute_name, error_message|
      errors.add(:base, error_message)  if attribute_name.to_s.eql?("id")
      errors.add(attribute_name.to_sym, error_message)
    end
  end

end
