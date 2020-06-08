# frozen_string_literal: true

require 'zeitwerk'
require 'dry-struct'
require 'dry-types'
require 'marc'
require 'sparql'
require 'linkeddata'
require 'byebug'
require 'hash'
require 'array'
require 'active_support/core_ext/hash'
require 'active_support/core_ext/module/delegation'
require 'faraday'
require 'logger'

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
end
