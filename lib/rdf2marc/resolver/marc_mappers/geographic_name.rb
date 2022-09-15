# frozen_string_literal: true

module Rdf2marc
  module Resolver
    module MarcMappers
      # Mapper for geographic terms.
      class GeographicName < BaseMapper
        def map
          field = marc_record['151'] || marc_record['181']
          {
            geographic_name: subfield_value(field, 'a'),
            form_subdivisions: subfield_values(field, 'v'),
            general_subdivisions: subfield_values(field, 'x'),
            chronological_subdivisions: subfield_values(field, 'y'),
            geographic_subdivisions: subfield_values(field, 'z'),
            authority_record_control_numbers: [uri],
            linkage: field['6'],
            field_link: subfield_values(field, '8')
          }
        end
      end
    end
  end
end
