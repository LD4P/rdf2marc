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
            control_fields: {
              general_info: general_information
            },
            main_entry_fields: {
              personal_name: personal_name
            },
            title_fields: {
              title_statement: title_statement
            }
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

      def personal_name
        person_term = query.path_first([[BF.contribution, BFLC.PrimaryContribution], [BF.agent, BF.Person], [RDF::RDFV.value]], subject_term: resource_term)
        return if person_term.nil?
        Resolver.resolve_loc_name(person_term.value, Models::MainEntryField::PersonalName)
      end
    end
  end
end