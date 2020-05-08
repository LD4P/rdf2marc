module Rdf2marc
  module Rdf2model
    class MonographInstance
      RESOURCE_TEMPLATES = [
          'ld4p:RT:bf2:Monograph:Instance:Un-nested'
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
            title: sparql.path_first(['bf:title', 'bf:mainTitle']),
            remainder_of_title: sparql.path_first(['bf:title', 'bf:subtitle'])
        }
      end

    end
  end
end