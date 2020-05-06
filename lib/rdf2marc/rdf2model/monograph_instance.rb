module Rdf2marc
  module Rdf2model
    class MonographInstance
      NAMESPACES = {
          bf: 'http://id.loc.gov/ontologies/bibframe/'
      }

      RESOURCE_TEMPLATES = [
          'ld4p:RT:bf2:Monograph:Instance:Un-nested'
      ]

      def initialize(graph)
        @graph = graph
        @sparql = Sparql.new(graph, NAMESPACES)
      end

      def generate
        record_params = {
            title_statement: title_statement
        }
        Rdf2marc::Models::Record.new(record_params)
      end

      private

      attr_reader :graph, :sparql

      def title
        query = <<-SPARQL
SELECT ?solut
WHERE
{ 
  ?x bf:mainTitle ?solut .
}
        SPARQL
        @title ||= sparql.query_first(query)
      end

      def title_statement
        {}.tap do |params|
          params[:title] = title if title
        end
      end
    end
  end
end