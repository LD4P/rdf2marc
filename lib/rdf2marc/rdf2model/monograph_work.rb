module Rdf2marc
  module Rdf2model
    class MonographWork
      RESOURCE_TEMPLATES = [
          'ld4p:RT:bf2:Monograph:Work:Un-nested'
      ]

      def initialize(graph, resource_uri)
        @graph = graph
        @resource_uri = resource_uri
        @resource_term = RDF::URI.new(resource_uri)
        @query = GraphQuery.new(graph)
      end

      def generate
        {
            general_info: general_information,
            title_statement: title_statement
        }
      end

      private

      attr_reader :graph, :query, :resource_uri, :resource_term

      def title_statement
        {
            medium: query.path_first_literal([BF.genreForm, RDF::RDFS.label], subject_term: resource_term),
        }
      end

      def general_information
        {
            language: language
        }
      end

      def language
        language_term = query.path_first([BF.language], subject_term: resource_term)
        return nil if language_term.nil? or ! language_term.value.start_with?('http://id.loc.gov/vocabulary/languages/')
        language_term.value.delete_prefix('http://id.loc.gov/vocabulary/languages/')
      end
    end
  end
end