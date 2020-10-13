# frozen_string_literal: true

class Hash
  def deep_compact
    each_with_object({}) do |(key, value), new_hash|
      new_value = value.is_a?(Hash) || value.is_a?(Array) ? value.deep_compact : value

      new_hash[key] = new_value unless new_value.nil? || new_value == []
    end
  end
end
