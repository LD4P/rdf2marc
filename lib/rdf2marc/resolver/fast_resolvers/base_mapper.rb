# frozen_string_literal: true

module Rdf2marc
  module Resolver
    module FastResolvers
      # @abstract Base Mapper for fast topics
      class BaseMapper
        def initialize(uri, graph)
          @uri = uri
          @graph = graph
        end

        attr_reader :uri, :graph

        def title
          graph.query(subject: RDF::URI(uri), predicate: SKOS.prefLabel).map(&:object).map(&:to_s).first
        end
      end
    end
  end
end
