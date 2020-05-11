class Array
  def deep_compact
    inject([]) do |new_array, value|
      new_value = (value.kind_of?(Hash) || value.is_a?(Array)) ? value.deep_compact : value
      new_array << new_value unless new_value.nil?
      new_array
    end
  end
end