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
      solutions = query(sparql)
      return nil if solutions.empty?

      solutions.first[var_name.to_sym]
    end

    def query_first_literal(sparql, var_name: 'solut')
      to_literal(query_first(sparql, var_name: var_name))
    end

    def query_all(sparql, var_name: 'solut')
      solutions = query(sparql)
      return nil if solutions.empty?

      solutions.map { |solution| solution[var_name.to_sym] }
    end

    def query_all_literal(sparql, var_name: 'solut')
      to_literals(query_all(sparql, var_name: var_name))
    end

    def query(sparql)
      ::SPARQL.execute(with_namespaces(sparql), graph)
    end

    def path_first(path, subject_uri: nil)
      query_string, subj = query_string_for_path(path, subject_uri: subject_uri)
      query_first(query_string, var_name: subj)
    end

    def path_first_literal(path, subject_uri: nil)
      query_string, subj = query_string_for_path(path, subject_uri: subject_uri)
      query_first_literal(query_string, var_name: subj)
    end

    def path_all(path, subject_uri: nil)
      query_string, subj = query_string_for_path(path, subject_uri: subject_uri)
      query_all(query_string, var_name: subj)
    end

    def path_all_literal(path, subject_uri: nil)
      query_string, subj = query_string_for_path(path, subject_uri: subject_uri)
      query_all_literal(query_string, var_name: subj)
    end

    private

    attr_reader :graph, :namespaces

    def with_namespaces(sparql)
      namespaces_str = namespaces.map { |prefix, uri| "PREFIX #{prefix}: <#{uri}>"}.join("\n")
      "#{namespaces_str}\n#{sparql}"
    end

    def query_string_for_path(path, subject_uri: nil)
      subj = subject_uri ? "<#{subject_uri}>" : "var0"
      where_str = path.map.with_index do |predicate, index|
        obj = "var#{index+1}"
        clause = "?#{subj} #{predicate} ?#{obj} ."
        subj = obj
        clause
      end
      query_string = <<-SPARQL
SELECT ?#{subj}
WHERE
{ 
  #{where_str.join("\n")}
}
      SPARQL
      [query_string, subj]
    end

    def to_literal(term)
      return nil if term.nil?

      raise 'Not a literal' unless term.is_a?(RDF::Literal)
      term.value
    end

    def to_literals(terms)
      return nil if terms.nil?

      terms.map { |term| to_literal(term)}
    end

  end
end