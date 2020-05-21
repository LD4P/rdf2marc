# frozen_string_literal: true

class Array
  def deep_compact
    each_with_object([]) do |value, new_array|
      new_value = value.is_a?(Hash) || value.is_a?(Array) ? value.deep_compact : value
      new_array << new_value unless new_value.nil?
    end
  end
end
