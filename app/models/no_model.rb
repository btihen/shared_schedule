# frozen_string_literal: true

# keep views simple - when an object is nil at least return "" in view
class NoModel
  def to_s
    ""
  end
  def method_missing(m, *args, &block)
    ""
  end
  def respond_to?(method_name, include_private = false)
    true
  end
end
