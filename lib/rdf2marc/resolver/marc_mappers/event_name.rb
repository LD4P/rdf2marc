# frozen_string_literal: true

module Rdf2marc
  module Resolver
    module MarcMappers
      # Mapper for event names.
      class EventName < BaseMapper
        def map
          field = marc_record['147'] || marc_record['111']
          {
            name: subfield_value(field, 'a'),
            locations: subfield_values(field, 'c'),
            date: subfield_value(field, 'd'),
            misc_infos: subfield_values(field, 'g'),
            form_subdivisions: subfield_values(field, 'v'),
            general_subdivisions: subfield_values(field, 'x'),
            chronological_subdivisions: subfield_values(field, 'y'),
            geographic_subdivisions: subfield_values(field, 'z'),
            authority_record_control_numbers: [uri],
            linkage: subfield_value(field, '6'),
            field_links: subfield_values(field, '8')
          }
        end
      end
    end
  end
end
