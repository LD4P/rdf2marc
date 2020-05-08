module Rdf2marc
  module Rdf2model
    class MonographWork
      RESOURCE_TEMPLATES = [
          'ld4p:RT:bf2:Monograph:Work:Un-nested'
      ]

      def initialize(graph, resource_uri)
        @graph = graph
        @resource_uri = resource_uri
        @sparql = Sparql.new(graph)
      end

      def generate
        {
            title_statement: title_statement
        }
      end

      private

      attr_reader :graph, :sparql, :resource_uri

      def title_statement
        {
            medium: sparql.path_first(['bf:genreForm', 'rdfs:label']),
        }
      end
    end
  end
end