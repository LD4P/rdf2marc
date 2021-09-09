# frozen_string_literal: true

require 'zeitwerk'
require 'dry-struct'
require 'dry-types'
require 'marc'
require 'sparql'
require 'json/ld'

require 'hash'
require 'array'

require 'active_support'
require 'active_support/core_ext/hash'
require 'active_support/core_ext/module/delegation'
require 'active_support/core_ext/module/attribute_accessors'

require 'faraday'
require 'faraday_middleware'
require 'faraday-http-cache'
require 'faraday/encoding'

require 'logger'
require 'fileutils'
require 'aws-sdk-s3'

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
    @cache ||= cache_implementation.constantize.new
  end

  mattr_accessor :cache_implementation, default: 'ActiveSupport::Cache::FileStore'
  mattr_accessor :s3_cache, default: {}
end
