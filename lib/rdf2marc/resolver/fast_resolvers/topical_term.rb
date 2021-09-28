# frozen_string_literal: true

module Rdf2marc
  module Resolver
    module FastResolvers
      # Mapper for topical terms.
      class TopicalTerm < BaseMapper
        def map
          {
            thesaurus: 'subfield2',
            heading_source: 'fast',
            topical_term_or_geo_name: title,
            authority_record_control_numbers: [uri]
          }
        end
      end
    end
  end
end
