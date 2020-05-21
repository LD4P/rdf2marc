# frozen_string_literal: true

module Rdf2marc
  module Rdf2model
    # Maps Monograph Work to model.
    class MonographWork
      RESOURCE_TEMPLATES = [
        'ld4p:RT:bf2:Monograph:Work:Un-nested'
      ].freeze

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
            personal_name: main_personal_name,
            corporate_name: main_corporate_name
          },
          title_fields: {
            title_statement: title_statement
          },
          subject_access_fields: subject_access_fields,
          added_entry_fields: {
            personal_names: added_personal_names,
            corporate_names: added_corporate_names
          }
        }
      end

      private

      attr_reader :graph, :query, :resource_uri, :resource_term

      def title_statement
        {
          medium: query.path_first_literal([BF.genreForm, RDF::RDFS.label], subject_term: resource_term)
        }
      end

      def general_information
        {
          language: language
        }
      end

      def language
        language_term = query.path_first([BF.language], subject_term: resource_term)
        return nil if language_term.nil? || !language_term.value.start_with?('http://id.loc.gov/vocabulary/languages/')

        language_term.value.delete_prefix('http://id.loc.gov/vocabulary/languages/')
      end

      def main_personal_name
        # Person or family
        person_term = query.path_first([[BF.contribution, BFLC.PrimaryContribution],
                                        [BF.agent, BF.Person],
                                        [RDF::RDFV.value]], subject_term: resource_term) ||
                      query.path_first([[BF.contribution, BFLC.PrimaryContribution],
                                        [BF.agent, BF.Family],
                                        [RDF::RDFV.value]], subject_term: resource_term)

        return if person_term.nil?

        Resolver.resolve_loc_name(person_term.value, Models::MainEntryField::PersonalName)
      end

      def main_corporate_name
        corporate_term = query.path_first([[BF.contribution, BFLC.PrimaryContribution],
                                           [BF.agent, BF.Organization],
                                           [RDF::RDFV.value]], subject_term: resource_term)

        return if corporate_term.nil?

        Resolver.resolve_loc_name(corporate_term.value, Models::MainEntryField::CorporateName)
      end

      def added_personal_names
        # Person or family
        person_terms = (query.path_all([[BF.contribution, BF.Contribution],
                                        [BF.agent, BF.Person],
                                        [RDF::RDFV.value]], subject_term: resource_term) || []) +
                       (query.path_first([[BF.contribution, BF.Contribution],
                                          [BF.agent, BF.Family],
                                          [RDF::RDFV.value]], subject_term: resource_term) || [])
        return if person_terms.nil?

        person_terms.map do |person_term|
          Resolver.resolve_loc_name(person_term.value,
                                    Models::AddedEntryField::PersonalName)
        end
      end

      def added_corporate_names
        corporate_terms = query.path_all([[BF.contribution, BF.Contribution],
                                          [BF.agent, BF.Organization],
                                          [RDF::RDFV.value]], subject_term: resource_term)
        return if corporate_terms.nil?

        corporate_terms.map do |corporate_term|
          Resolver.resolve_loc_name(corporate_term.value,
                                    Models::AddedEntryField::CorporateName)
        end
      end

      def subject_access_fields
        subject_terms = query.path_all([BF.subject], subject_term: resource_term)
        # TODO: Determine type of subject access field
        {}
      end
    end
  end
end
