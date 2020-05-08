module Rdf2marc
  class GraphHelper

    def initialize(graph)
      @graph = graph
      @sparql = Sparql.new(graph)
    end

    def resource_template
      @resource_template ||= sparql.path_first(['sinopia:hasResourceTemplate'])
    end

    def uri
      query = <<-SPARQL
SELECT ?solut
WHERE
{ 
  ?solut sinopia:hasResourceTemplate ?x .
}
      SPARQL
      @uri ||= sparql.query_first(query)
    end

    private

    attr_reader :graph, :sparql
  end
end