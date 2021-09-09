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

        def contributions
          @contributions ||= Queries::Contributions.new(item.work.query)
        end

        def added_personal_names
          # Person or family
          person_terms = contributions.with_type(BF.Person, BF.Family)

          person_terms.sort.map do |person_term|
            if person_term.is_a?(RDF::Literal)
              { thesaurus: 'not_specified', personal_name: person_term.value }
            else
              Resolver.resolve_model(person_term&.value, Models::General::PersonalName)
            end
          end
        end

        def added_corporate_names
          corporate_terms = contributions.with_type(BF.Organization)

          corporate_terms.sort.map do |corporate_term|
            if corporate_term.is_a?(RDF::Literal)
              { thesaurus: 'not_specified', corporate_name: corporate_term.value }
            else
              Resolver.resolve_model(corporate_term&.value,
                                     Models::General::CorporateName)
            end
          end
        end

        def added_meeting_names
          meeting_terms = contributions.with_type(BF.Meeting)

          meeting_terms.sort.map do |meeting_term|
            if meeting_term.is_a?(RDF::Literal)
              { thesaurus: 'not_specified', meeting_name: meeting_term.value }
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
