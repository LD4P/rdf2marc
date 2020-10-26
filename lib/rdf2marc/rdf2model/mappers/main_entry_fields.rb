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
          person_term = item.work.query.path_first([[BF.contribution, BFLC.PrimaryContribution],
                                                    [BF.agent, BF.Person], [RDF::RDFV.value]]) ||
                        item.work.query.path_first([[BF.contribution, BFLC.PrimaryContribution],
                                                    [BF.agent, BF.Family], [RDF::RDFV.value]])

          return { thesaurus: 'not_specified', personal_name: person_term.value } if person_term.is_a?(RDF::Literal)

          Resolver.resolve_model(person_term&.value, Models::General::PersonalName)
        end

        def main_corporate_name
          corporate_term = item.work.query.path_first([[BF.contribution, BFLC.PrimaryContribution],
                                                       [BF.agent, BF.Organization],
                                                       [RDF::RDFV.value]])

          if corporate_term.is_a?(RDF::Literal)
            return { thesaurus: 'not_specified', corporate_name: corporate_term.value }
          end

          Resolver.resolve_model(corporate_term&.value, Models::General::CorporateName)
        end

        def main_meeting_name
          meeting_term = item.work.query.path_first([[BF.contribution, BFLC.PrimaryContribution],
                                                     [BF.agent, BF.Meeting],
                                                     [RDF::RDFV.value]])

          return { thesaurus: 'not_specified', meeting_name: meeting_term.value } if meeting_term.is_a?(RDF::Literal)

          Resolver.resolve_model(meeting_term&.value, Models::General::MeetingName)
        end
      end
    end
  end
end
