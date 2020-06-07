# frozen_string_literal: true

module Rdf2marc
  module Rdf2model
    module Mappers
      # Mapping to Main Entry Fields model.
      class MainEntryFields < BaseMapper
        def generate
          {
            personal_name: main_personal_name,
            corporate_name: main_corporate_name,
            meeting_name: main_meeting_name
          }
        end

        private

        def main_personal_name
          # Person or family
          person_uri = item.work.query.path_first_uri([[BF.contribution, BFLC.PrimaryContribution],
                                                       [BF.agent, BF.Person], [RDF::RDFV.value]]) ||
                       item.work.query.path_first_uri([[BF.contribution, BFLC.PrimaryContribution],
                                                       [BF.agent, BF.Family], [RDF::RDFV.value]])

          Resolver.resolve_model(person_uri, Models::General::PersonalName)
        end

        def main_corporate_name
          corporate_uri = item.work.query.path_first_uri([[BF.contribution, BFLC.PrimaryContribution],
                                                          [BF.agent, BF.Organization],
                                                          [RDF::RDFV.value]])

          Resolver.resolve_model(corporate_uri, Models::General::CorporateName)
        end

        def main_meeting_name
          meeting_uri = item.work.query.path_first_uri([[BF.contribution, BFLC.PrimaryContribution],
                                                        [BF.agent, BF.Meeting],
                                                        [RDF::RDFV.value]])

          Resolver.resolve_model(meeting_uri, Models::General::MeetingName)
        end
      end
    end
  end
end
