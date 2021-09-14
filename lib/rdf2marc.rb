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
  # Adapter for RDF.rb to use Faraday (and it's caching infrastructure)
  class FaradayAdapter < RDF::Util::File::HttpAdapter
    def initialize(conn) # rubocop:disable Lint/MissingSuper
      @conn = conn
    end

    def open_url(base_uri, headers: {}, **_options)
      response = @conn.get(base_uri, nil, self.class.headers(headers: headers))
      raise IOError, "<#{base_uri}>: #{response.status}" unless response.success?

      # If a Location is returned, it defines the base resource for this file, not it's actual ending location
      document_options = {
        base_uri: RDF::URI(response.headers.fetch(:location, base_uri)),
        code: response.status,
        headers: response.headers.to_h.transform_keys { |k| k.underscore.to_sym }
      }

      remote_document = RDF::Util::File::RemoteDocument.new(response.body, document_options)
      remote_document.content_type
      remote_document
    end
  end

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

  def self.reset
    @http_adapter = nil
    @cache = nil
    setup
  end

  def self.setup
    # This has to be reset after the cache_implementation is changed
    warn "Setting http_adapter to be #{http_adapter}, with cache: #{cache}"

    RDF::Util::File.http_adapter = FaradayAdapter.new(http_adapter)
  end

  def self.http_adapter
    @http_adapter ||= Faraday.new do |builder|
      builder.use :http_cache, store: cache
      builder.use FaradayMiddleware::FollowRedirects
      builder.response :encoding # use Faraday::Encoding middleware
      builder.adapter Faraday.default_adapter
    end
  end

  def self.cache_implementation=(value)
    @cache_implementation = value
    warn "Setting cache impl to #{value}"
    reset
  end

  def self.cache_implementation
    @cache_implementation || ['ActiveSupport::Cache::FileStore', 'cache']
  end
end

Rdf2marc.setup
