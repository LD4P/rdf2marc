class Hash
  def deep_compact
    inject({}) do |new_hash, (k,v)|
      if !v.nil?
        new_hash[k] = v.kind_of?(Hash) ? v.deep_compact : v
      end
      new_hash
    end
  end
end