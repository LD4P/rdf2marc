# frozen_string_literal: true

module Rdf2marc
  module Rdf2model
    module Mappers
      # Mapping to Control Fields model.
      class ControlFields < BaseMapper
        def generate
          {
            latest_transaction: latest_transaction,
            general_info: {
              place: place,
              date_entered: date_entered,
              date1: item.instance.query.path_first_literal([[BF.provisionActivity, BF.Publication], [BF.date]]),
              language: language
            }
          }
        end

        private

        def place
          place_uri = item.instance.query.path_first_uri([[BF.provisionActivity, BF.Publication], BF.place])
          # Look up the MARC record for this place and return the marc geographicAreas code (e.g.: an-cn-on).
          code = Resolver.resolve_geographic_area_code(place_uri)

          Resolver::CountryCode.resolve_from_geographic_area_code(code)
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

        def language
          language_uri = item.work.query.path_first_uri([BF.language])
          return nil if language_uri.nil? || !language_uri.start_with?(%r{https?://id.loc.gov/vocabulary/languages/})

          language_uri.sub(%r{^https?://id.loc.gov/vocabulary/languages/}, '')
        end
      end
    end
  end
end
