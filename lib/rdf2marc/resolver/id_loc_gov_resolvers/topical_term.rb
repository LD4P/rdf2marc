# frozen_string_literal: true

module Rdf2marc
  module Resolver
    module IdLocGovResolvers
      # Mapper for topical terms.
      class TopicalTerm < BaseMapper
        def map
          field = marc_record['150']
          {
            topical_term_or_geo_name: subfield_value(field, 'a'),
            topical_term_following_geo_name: subfield_value(field, 'b'),
            misc_infos: subfield_values(field, 'g'),
            form_subdivisions: subfield_values(field, 'v'),
            general_subdivisions: subfield_values(field, 'x'),
            chronological_subdivisions: subfield_values(field, 'y'),
            geographic_subdivisions: subfield_values(field, 'z'),
            authority_record_control_numbers: [uri],
            linkage: field['6'],
            field_links: subfield_values(field, '8')
          }
        end
      end
    end
  end
end
