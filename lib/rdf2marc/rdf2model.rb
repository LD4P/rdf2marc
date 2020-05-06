module Rdf2marc
  module Rdf2model
    NAMESPACES = {
        sinopia: 'http://sinopia.io/vocabulary/'
    }

    def self.to_model(graph)
      query = <<-SPARQL
SELECT ?solut
WHERE
{ 
  ?x sinopia:hasResourceTemplate ?solut .
}
      SPARQL
      resource_template = Sparql.new(graph, NAMESPACES).query_first(query)
      clazz = case resource_template
              when *MonographInstance::RESOURCE_TEMPLATES
                MonographInstance
              else
                raise 'Unknown resource template or resource template not found'
              end
      clazz.new(graph).generate
    end
  end
end