# frozen_string_literal: true

module Rdf2marc
  module Rdf2model
    module Mappers
      # Mapping to Control Fields model.
      class ControlFields < BaseMapper
        def generate
          {
            latest_transaction:,
            general_info: {
              place:,
              date_entered:,
              date1: item.instance.query.path_first_literal([[BF.provisionActivity, BF.Publication], [BF.date]]),
              language:,
              book_illustrative_content:
            }
          }
        end

        private

        def place
          place_uris = item.instance.query.path_all_uri([[BF.provisionActivity, BF.Publication], BF.place])
          place_uri = place_uris.find { |uri| Resolver.id_loc_gov?(uri) }

          Resolver.resolve_country_code(place_uri) || 'xx'
        end

        def latest_transaction
          date_literal = item.admin_metadata.query.path_first_literal([BF.changeDate])
          parse_date(date_literal)
        end

        def date_entered
          date_literal = item.admin_metadata.query.path_first_literal([BF.creationDate])
          parse_date(date_literal)
        end

        def parse_date(date_literal)
          return nil if date_literal.nil?

          DateTime.iso8601(date_literal)
        rescue Date::Error
          raise BadRequestError, "#{date_literal} is an invalid date."
        end

        LANGUAGE_PARTS = ['text', 'sung or spoken text'].freeze

        def language
          language_nodes = item.work.query.path_all([BF.language])
          preferred_nodes = language_nodes.select do |node|
            LANGUAGE_PARTS.include?(item.work.query.path_first_literal([BF.part], subject_term: node)&.downcase)
          end

          language_blank_node = preferred_nodes.first || language_nodes.first
          return nil if language_blank_node.nil?

          language_node = item.work.query.path_first([RDF::RDFS.label], subject_term: language_blank_node)
          return nil unless language_node.is_a?(RDF::URI)

          language_uri = language_node.value

          return nil if language_uri.nil? || !language_uri.start_with?(%r{https?://id.loc.gov/vocabulary/languages/})

          language_uri.sub(%r{^https?://id.loc.gov/vocabulary/languages/}, '')
        end

        def book_illustrative_content
          illustrative_content_uri = item.instance.query.path_first_uri([BF.illustrativeContent]) ||
                                     item.work.query.path_first_uri([BF.illustrativeContent])
          return nil if illustrative_content_uri.blank?

          LiteralOrRemoteResolver.resolve_label(term: illustrative_content_uri, item:)
        end
      end
    end
  end
end
