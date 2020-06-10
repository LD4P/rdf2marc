# frozen_string_literal: true

module Rdf2marc
  module Caches
    # No caching.
    class NullCache
      def set_cache(key, value); end

      def get_cache(_key)
        nil
      end
    end
  end
end
