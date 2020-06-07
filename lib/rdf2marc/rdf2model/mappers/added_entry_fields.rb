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
          person_uris = item.work.query.path_all_uri([[BF.contribution, BF.Contribution],
                                                      [BF.agent, BF.Person], [RDF::RDFV.value]]) +
                        (item.work.query.path_first_uri([[BF.contribution, BF.Contribution],
                                                         [BF.agent, BF.Family],
                                                         [RDF::RDFV.value]]) || [])
          person_uris.map do |person_uri|
            Resolver.resolve_model(person_uri,
                                   Models::General::PersonalName)
          end
        end

        def added_corporate_names
          corporate_uris = item.work.query.path_all_uri([[BF.contribution, BF.Contribution],
                                                         [BF.agent, BF.Organization], [RDF::RDFV.value]])
          corporate_uris.map do |corporate_uri|
            Resolver.resolve_model(corporate_uri,
                                   Models::General::CorporateName)
          end
        end

        def added_meeting_names
          meeting_uris = item.work.query.path_all_uri([[BF.contribution, BF.Contribution],
                                                       [BF.agent, BF.Meeting], [RDF::RDFV.value]])
          meeting_uris.map do |meeting_uri|
            Resolver.resolve_model(meeting_uri,
                                   Models::General::MeetingName)
          end
        end
      end
    end
  end
end
