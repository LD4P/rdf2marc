module Rdf2marc
  BF = RDF::Vocabulary.new('http://id.loc.gov/ontologies/bibframe/')
  SINOPIA = RDF::Vocabulary.new('http://sinopia.io/vocabulary/')
  LC_VOCAB = RDF::Vocabulary.new('http://id.loc.gov/vocabulary/')
  class GraphQuery
    QueryPart = Struct.new(:pred, :class)

    def initialize(graph)
      @graph = graph
    end

    def path_first(path, subject_term: nil)
      patterns, subj = patterns_for_path(path, subject_term: subject_term)
      query_first(patterns, subj)
    end

    def path_first_literal(path, subject_term: nil)
      to_literal(path_first(path, subject_term: subject_term))
    end

    def path_all(path, subject_term: nil)
      patterns, subj = patterns_for_path(path, subject_term: subject_term)
      query_all(patterns, subj)
    end

    def path_all_literal(path, subject_term: nil)
      patterns, subj = patterns_for_path(path, subject_term: subject_term)
      to_literals(query_all(patterns, subj))
    end

    private

    attr_reader :graph

    def patterns_for_path(path, subject_term: nil)
      subj = subject_term || :var0
      patterns = []
      path.map.with_index do |path_part, index|
        predicate, type = if path_part.is_a?(Array)
           path_part
        else
          [path_part, nil]
        end
        obj = "var#{index+1}".to_sym
        patterns << RDF::Query::Pattern.new(subj, predicate, obj)
        patterns << RDF::Query::Pattern.new(obj,  RDF.type, type) if type
        subj = obj
      end
      [patterns, subj]
    end

    def query_first(patterns, var)
      solutions =  RDF::Query.new(patterns).execute(graph)
      return nil if solutions.empty?

      solutions.first[var]
    end

    def query_all(patterns, var)
      solutions =  RDF::Query.new(patterns).execute(graph)
      return nil if solutions.empty?

      solutions.map { |solution| solution[var] }
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