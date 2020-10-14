# frozen_string_literal: true

module Rdf2marc
  module Rdf2model
    module Mappers
      # Mapping to Holding Etc. Fields model.
      class HoldingsEtcFields < BaseMapper
        def generate
          {
            description_conversion_infos: [
              {
                conversion_process: 'Sinopia rdf2marc',
                conversion_date: Date.today,
                source_metadata_identifier: item.instance.term.value,
                uri: 'https://github.com/LD4P/rdf2marc'
              }
            ],
            electronic_locations: electronic_locations
          }
        end

        private

        def electronic_locations
          item.instance.query.path_all_uri([[BF.electronicLocator]]).sort.map do |uri|
            { uris: [uri] }
          end
        end
      end
    end
  end
end
