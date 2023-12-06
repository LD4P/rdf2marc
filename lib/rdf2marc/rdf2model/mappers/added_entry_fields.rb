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
          added_entry_names([BF.Person, BF.Family], :personal_name, Models::General::PersonalName)
        end

        def added_corporate_names
          added_entry_names(BF.Organization, :corporate_name, Models::General::CorporateName)
        end

        def added_meeting_names
          added_entry_names(BF.Meeting, :meeting_name, Models::General::MeetingName)
        end

        def added_entry_names(types, key_symbol, model_class)
          terms_with_roles = contributions.contributors_of_type_with_roles(types)
          # terms_with_roles is [[contributor, roles], [contributor, roles]];
          #   we sort it by contributor
          terms_with_roles.sort_by { |term_with_roles| term_with_roles[0] }.map do |term_with_roles|
            contrib_term = term_with_roles[0]
            role_uris = term_with_roles[1]

            # contrib term can be Array if there are two literals, e.g.
            #   _:b8 a <http://id.loc.gov/ontologies/bibframe/Person>;
            #      <http://www.w3.org/1999/02/22-rdf-syntax-ns#value> "Jung, Carl", "Kennedy Family".
            if contrib_term.is_a?(Array)
              contrib_term.sort.map { |term| added_entry_name_with_roles(term, role_uris, key_symbol, model_class) }
            else
              added_entry_name_with_roles(contrib_term, role_uris, key_symbol, model_class)
            end
          end.flatten
        end

        def added_entry_name_with_roles(contrib_term, role_uris, key_symbol, model_class)
          result = LiteralOrRemoteResolver.resolve_model(term: contrib_term, item:, key_symbol:,
                                                         model: model_class)
          result[:relator_terms] = relator_terms(role_uris) if result && relator_terms(role_uris).present?
          result
        end

        def relator_terms(role_uris)
          role_uris.sort.map { |uri| LiteralOrRemoteResolver.resolve_label(term: uri, item:) }
        end
      end
    end
  end
end
