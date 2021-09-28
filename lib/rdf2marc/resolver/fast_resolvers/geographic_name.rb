# frozen_string_literal: true

module Rdf2marc
  module Resolver
    module FastResolvers
      # Mapper for geographic terms.
      class GeographicName < BaseMapper
        def map
          {
            thesaurus: 'subfield2',
            source: 'fast',
            geographic_name: title,
            authority_record_control_numbers: [uri]
          }
        end
      end
    end
  end
end
