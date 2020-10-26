# frozen_string_literal: true

module Rdf2marc
  module Resolver
    module IdLocGovResolvers
      # Mapper for meeting names.
      class MeetingName < BaseMapper
        def map
          field = marc_record['111']
          {
            type: name_type_for(field.indicator1),
            thesaurus: 'lcsh',
            meeting_name: subfield_value(field, 'a', clean: true),
            meeting_locations: subfield_values(field, 'c', clean: true),
            meeting_dates: subfield_values(field, 'd', clean: true),
            subordinate_units: subfield_values(field, 'e'),
            work_date: field['f'],
            misc_infos: subfield_values(field, 'g'),
            medium: field['h'],
            # No relationship_info: subfield_values(field, 'i')
            relator_terms: subfield_values(field, 'j'),
            form_subheadings: subfield_values(field, 'k'),
            work_language: field['l'],
            part_numbers: subfield_values(field, 'n', clean: true),
            part_names: subfield_values(field, 'p'),
            following_meeting_name: field['q'],
            versions: subfield_values(field, 's'),
            work_title: field['t'],
            # No affiliation: field['u'],
            form_subdivisions: subfield_values(field, 'v'),
            general_subdivisions: subfield_values(field, 'x'),
            # No issn field['x']
            chronological_subdivisions: subfield_values(field, 'y'),
            geographic_subdivisions: subfield_values(field, 'z'),
            authority_record_control_numbers: [uri],
            # No uri: field['1'],
            # No heading_source: field['2'],
            # No materials_specified: field['3'],
            # No relationshipa: subfield_values(field, '4'),
            linkage: field['6'],
            field_links: subfield_values(field, '8')
          }
        end

        private

        def name_type_for(indicator1)
          case indicator1
          when '0'
            'inverted'
          when '1'
            'jurisdiction'
          when '2'
            'direct'
          else ' '
          end
        end
      end
    end
  end
end
