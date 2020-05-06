module Rdf2marc
  class Sparql
    def initialize(graph, namespaces)
      @graph = graph
      @namespaces = namespaces
    end

    def query_first(sparql, var_name: 'solut')
      solution = query(sparql)
      return nil if solution.empty?

      solution.first[var_name.to_sym].value
    end

    def query(sparql)
      ::SPARQL.execute(with_namespaces(sparql), graph)
    end

    private

    attr_reader :graph, :namespaces

    def with_namespaces(sparql)
      namespaces_str = namespaces.map { |prefix, uri| "PREFIX #{prefix}: <#{uri}>"}.join("\n")
      "#{namespaces_str}\n#{sparql}"
    end
  end
end