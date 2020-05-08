module Rdf2marc
  class Sparql
    NAMESPACES = {
        bf: 'http://id.loc.gov/ontologies/bibframe/',
        sinopia: 'http://sinopia.io/vocabulary/',
        rdfs: 'http://www.w3.org/2000/01/rdf-schema#'
    }

    def initialize(graph, addl_namespaces: {})
      @graph = graph
      @namespaces = NAMESPACES.merge(addl_namespaces)
    end

    def query_first(sparql, var_name: 'solut')
      solution = query(sparql)
      return nil if solution.empty?

      solution.first[var_name.to_sym].value
    end

    def query(sparql)
      ::SPARQL.execute(with_namespaces(sparql), graph)
    end

    def path_first(path, subject_uri: nil)
      subj = subject_uri ? "<#{subject_uri}>" : "var0"
      where_str = path.map.with_index do |predicate, index|
        obj = "var#{index+1}"
        clause = "?#{subj} #{predicate} ?#{obj} ."
        subj = obj
        clause
      end
      query = <<-SPARQL
SELECT ?#{subj}
WHERE
{ 
  #{where_str.join("\n")}
}
      SPARQL
      query_first(query, var_name: subj)
    end

    private

    attr_reader :graph, :namespaces

    def with_namespaces(sparql)
      namespaces_str = namespaces.map { |prefix, uri| "PREFIX #{prefix}: <#{uri}>"}.join("\n")
      "#{namespaces_str}\n#{sparql}"
    end
  end
end