# frozen_string_literal: true

module Rdf2marc
  module Rdf2model
    module Mappers
      # Mapping to Added Entry Fields model.
      class AddedEntryFields < BaseMapper
        def generate
          {
            personal_names: added_personal_names,
            corporate_names: added_corporate_names,
            meeting_names: added_meeting_names
          }
        end

        private

        def added_personal_names
          # Person or family
          person_terms = item.work.query.path_all([[BF.contribution, BF.Contribution],
                                                   [BF.agent, BF.Person], [RDF::RDFV.value]]) +
                         (item.work.query.path_first([[BF.contribution, BF.Contribution],
                                                      [BF.agent, BF.Family],
                                                      [RDF::RDFV.value]]) || [])
          person_terms.map do |person_term|
            if person_term.is_a?(RDF::Literal)
              { personal_name: person_term.value }
            else
              Resolver.resolve_model(person_term&.value, Models::General::PersonalName)
            end
          end
        end

        def added_corporate_names
          corporate_terms = item.work.query.path_all([[BF.contribution, BF.Contribution],
                                                      [BF.agent, BF.Organization], [RDF::RDFV.value]])
          corporate_terms.map do |corporate_term|
            if corporate_term.is_a?(RDF::Literal)
              { corporate_name: corporate_term.value }
            else
              Resolver.resolve_model(corporate_term&.value,
                                     Models::General::CorporateName)
            end
          end
        end

        def added_meeting_names
          meeting_terms = item.work.query.path_all([[BF.contribution, BF.Contribution],
                                                    [BF.agent, BF.Meeting], [RDF::RDFV.value]])
          meeting_terms.map do |meeting_term|
            if meeting_term.is_a?(RDF::Literal)
              { meeting_name: meeting_term.value }
            else
              Resolver.resolve_model(meeting_term&.value,
                                     Models::General::MeetingName)
            end
          end
        end
      end
    end
  end
end
