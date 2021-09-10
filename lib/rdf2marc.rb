# frozen_string_literal: true

require 'bundler'
Bundler.require(:default)

require 'active_support/core_ext/hash'

# Add some monkeypatches
require 'hash'
require 'array'

loader = Zeitwerk::Loader.new
loader.push_dir(File.absolute_path("#{__FILE__}/.."))
loader.setup

# Maps RDF to MARC.
module Rdf2marc
  # Base class for Exceptions
  class Error < StandardError; end

  # Requested conversion is not supported.
  class UnhandledError < Error; end

  # Error with provided resource.
  class BadRequestError < Error; end

  # Error with mapping.
  class MappingError < Error; end

  GraphContext = Struct.new(:graph, :term, :query)

  ItemContext = Struct.new(:instance, :work, :admin_metadata)

  def self.cache
    @cache ||= lookup_store(cache_implementation)
  end

  def self.lookup_store(store, *parameters)
    case store
    when String
      store.constantize.new(*parameters)
    when Array
      lookup_store(*store)
    else
      raise 'Unknow type of cache store'
    end
  end

  mattr_accessor :cache_implementation, default: ['ActiveSupport::Cache::FileStore', 'cache']
end
