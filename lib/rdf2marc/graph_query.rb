# frozen_string_literal: true

module Rdf2marc
  BF = RDF::Vocabulary.new('http://id.loc.gov/ontologies/bibframe/')
  SINOPIA = RDF::Vocabulary.new('http://sinopia.io/vocabulary/')
  LC_VOCAB = RDF::Vocabulary.new('http://id.loc.gov/vocabulary/')
  BFLC = RDF::Vocabulary.new('http://id.loc.gov/ontologies/bflc/')
  SKOS = RDF::Vocabulary.new('http://www.w3.org/2004/02/skos/core#')
  MADS = RDF::Vocabulary.new('http://www.loc.gov/mads/rdf/v1#')
  FAST = RDF::Vocabulary.new('http://id.worldcat.org/fast/ontology/1.0/#')
  # Queries graph using graph patterns.
  class GraphQuery
    def initialize(graph, default_subject_term: nil)
      @graph = graph
      @default_subject_term = default_subject_term
    end

    def path_first(path, subject_term: default_subject_term)
      patterns, subj = patterns_for_path(path, subject_term: subject_term)
      query_first(patterns, subj)
    end

    def path_first_literal(path, subject_term: default_subject_term)
      to_literal(path_first(path, subject_term: subject_term))
    end

    def path_first_uri(path, subject_term: default_subject_term)
      to_uri(path_first(path, subject_term: subject_term))
    end

    def path_all(path, subject_term: default_subject_term)
      patterns, subj = patterns_for_path(path, subject_term: subject_term)
      query_all(patterns, subj)
    end

    def path_all_literal(path, subject_term: default_subject_term)
      patterns, subj = patterns_for_path(path, subject_term: subject_term)
      to_literals(query_all(patterns, subj))
    end

    def path_all_uri(path, subject_term: default_subject_term)
      patterns, subj = patterns_for_path(path, subject_term: subject_term)
      to_uris(query_all(patterns, subj))
    end

    private

    attr_reader :graph, :default_subject_term

    def patterns_for_path(path, subject_term: nil)
      subj = subject_term || :var0
      patterns = []
      path.map.with_index do |path_part, index|
        predicate, type = if path_part.is_a?(Array)
                            path_part
                          else
                            [path_part, nil]
                          end
        obj = "var#{index + 1}".to_sym # rubocop:disable Lint/SymbolConversion
        patterns << RDF::Query::Pattern.new(subj, predicate, obj)
        patterns << RDF::Query::Pattern.new(obj,  RDF.type, type) if type
        subj = obj
      end
      [patterns, subj]
    end

    def query_first(patterns, var)
      solutions = RDF::Query.new(patterns).execute(graph)
      return nil if solutions.empty?

      solutions.map { |solution| solution[var] }.min
    end

    def query_all(patterns, var)
      solutions = RDF::Query.new(patterns).execute(graph)

      solutions.map { |solution| solution[var] }
    end

    def to_literal(term)
      return nil if term.nil?

      raise MappingError, "Not a literal: #{term}" unless term.is_a?(RDF::Literal)

      term.value
    end

    def to_uri(term)
      return nil if term.nil?

      raise MappingError, "Not a URI: #{term}" unless term.is_a?(RDF::URI)

      term.value
    end

    def to_literals(terms)
      terms.map { |term| to_literal(term) }
    end

    def to_uris(terms)
      terms.map { |term| to_uri(term) }
    end
  end
end
