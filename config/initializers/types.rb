# config/initializers/types.rb
# Use on_load to avoid DEPRECATION warnings
# https://github.com/rails/rails/issues/36363
ActiveSupport.on_load(:active_record) do
  ActiveModel::Type.register(:trimmed_text, TrimmedText)
  ActiveModel::Type.register(:squished_string, SquishedString)
  # ActiveModel::Type.register(:date_no_year, DateNoYear)
  # ActiveModel::Type.register(:string_array, StringArray)
  # ActiveModel::Type.register(:integer_array, IntegerArray)
end
