# frozen_string_literal: true

module Rdf2marc
  module Resolver
    CODE_DATATYPE_URI = RDF::URI('http://id.loc.gov/datatypes/orgs/code')

    # Resolver for cultural heritage organization codes from id.loc.gov
    class CulturalHeritageInstitution
      def self.resolve_code(uri)
        graph = RDF::Graph.load("#{uri}.skos.nt")
        query = GraphQuery.new(graph)
        notation_terms = query.path_all([SKOS.notation], subject_term: RDF::URI.new(uri))
        notation_terms.find { |term| term.is_a?(RDF::Literal) && term.datatype == CODE_DATATYPE_URI }&.value
      end
    end
  end
end
