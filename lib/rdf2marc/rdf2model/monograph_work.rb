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
          number_and_code_fields: {
            geographic_area_code: geographic_area_code,
            lc_call_numbers: lc_call_numbers
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
        language_uri = query.path_first_uri([BF.language], subject_term: resource_term)
        return nil if language_uri.nil? || !language_uri.start_with?('http://id.loc.gov/vocabulary/languages/')

        language_uri.delete_prefix('http://id.loc.gov/vocabulary/languages/')
      end

      def main_personal_name
        # Person or family
        person_uri = query.path_first_uri([[BF.contribution, BFLC.PrimaryContribution],
                                           [BF.agent, BF.Person],
                                           [RDF::RDFV.value]], subject_term: resource_term) ||
                     query.path_first_uri([[BF.contribution, BFLC.PrimaryContribution],
                                           [BF.agent, BF.Family],
                                           [RDF::RDFV.value]], subject_term: resource_term)

        Resolver.resolve(person_uri, Models::MainEntryField::PersonalName)
      end

      def main_corporate_name
        corporate_uri = query.path_first_uri([[BF.contribution, BFLC.PrimaryContribution],
                                              [BF.agent, BF.Organization],
                                              [RDF::RDFV.value]], subject_term: resource_term)

        Resolver.resolve(corporate_uri, Models::MainEntryField::CorporateName)
      end

      def added_personal_names
        # Person or family
        person_uris = query.path_all_uri([[BF.contribution, BF.Contribution],
                                          [BF.agent, BF.Person],
                                          [RDF::RDFV.value]], subject_term: resource_term) +
                      (query.path_first_uri([[BF.contribution, BF.Contribution],
                                             [BF.agent, BF.Family],
                                             [RDF::RDFV.value]], subject_term: resource_term) || [])
        person_uris.map do |person_uri|
          Resolver.resolve(person_uri,
                           Models::AddedEntryField::PersonalName)
        end
      end

      def added_corporate_names
        corporate_uris = query.path_all_uri([[BF.contribution, BF.Contribution],
                                             [BF.agent, BF.Organization],
                                             [RDF::RDFV.value]], subject_term: resource_term)
        corporate_uris.map do |corporate_uri|
          Resolver.resolve(corporate_uri,
                           Models::AddedEntryField::CorporateName)
        end
      end

      def subject_access_fields
        subject_terms = query.path_all([BF.subject], subject_term: resource_term)
        # TODO: Determine type of subject access field
        {}
      end

      def lc_call_numbers
        classification_terms = query.path_all([[BF.classification, BF.ClassificationLcc]], subject_term: resource_term)

        classification_terms.map do |classification_term|
          {
            classification_numbers: query.path_all_literal([BF.classificationPortion],
                                                           subject_term: classification_term),
            # Can be multiple, however only using one.
            item_number: query.path_first_literal([BF.itemPortion], subject_term: classification_term)
          }
        end
      end

      def geographic_area_code
        gac_uris = query.path_all_uri([BF.geographicCoverage], subject_term: resource_term)
        gacs = gac_uris.map do |gac_uri|
          Resolver.resolve(gac_uri, Rdf2marc::Models::NumberAndCodeField::GeographicAreaCode, 'geographic_area_code')
        end
        {
          geographic_area_codes: gacs
        }
      end
    end
  end
end
