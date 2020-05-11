module Rdf2marc
  module Rdf2model
    class MonographWork
      RESOURCE_TEMPLATES = [
          'ld4p:RT:bf2:Monograph:Work:Un-nested'
      ]

      def initialize(graph, resource_uri)
        @graph = graph
        @resource_uri = resource_uri
        @resource_term = RDF::URI.new(resource_uri)
        @query = GraphQuery.new(graph)
      end

      def generate
        {
            title_statement: title_statement
        }
      end

      private

      attr_reader :graph, :query, :resource_uri, :resource_term

      def title_statement
        {
            medium: query.path_first_literal([BF.genreForm, RDF::RDFS.label], subject_term: resource_term),
        }
      end
    end
  end
end