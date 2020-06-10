# frozen_string_literal: true

module Rdf2marc
  # Global cache
  class Cache
    include Singleton

    def initialize
      @cache_implementation = Caches::NullCache.new
    end

    class << self
      def configure(cache)
        instance.cache_implementation = cache
        self
      end

      delegate :set_cache, :get_cache, to: :instance
    end

    delegate :set_cache, :get_cache, to: :cache_implementation

    attr_accessor :cache_implementation
  end
end
