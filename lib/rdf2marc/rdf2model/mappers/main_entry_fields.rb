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
          person_term = primary_contributions.first_with_type(BF.Person, BF.Family)
          main_entry_name(person_term, :personal_name, Models::General::PersonalName)
        end

        def main_corporate_name
          corporate_term = primary_contributions.first_with_type(BF.Organization)
          main_entry_name(corporate_term, :corporate_name, Models::General::CorporateName)
        end

        def main_meeting_name
          meeting_term = primary_contributions.first_with_type(BF.Meeting)
          main_entry_name(meeting_term, :meeting_name, Models::General::MeetingName)
        end

        def primary_contributions
          @primary_contributions ||= Queries::PrimaryContributions.new(item.work.query)
        end

        def main_entry_name(term, key_symbol, model_class)
          result = LiteralOrRemoteResolver.resolve_model(term: term, item: item, key_symbol: key_symbol,
                                                         model: model_class)
          result[:relator_terms] = main_relator_terms if result && main_relator_terms.present?
          result
        end

        def main_relator_terms
          role_uris = item.work.query.path_all([[BF.contribution, BFLC.PrimaryContribution], [BF.role]])
          role_uris.sort.map { |uri| LiteralOrRemoteResolver.resolve_label(term: uri, item: item) }
        end
      end
    end
  end
end
