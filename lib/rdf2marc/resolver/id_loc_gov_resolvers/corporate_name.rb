# frozen_string_literal: true

module Rdf2marc
  module Resolver
    module IdLocGovResolvers
      # Mapper for corporate names.
      class CorporateName < BaseMapper
        def map
          field = marc_record['110']
          {
            type: name_type_for(field.indicator1),
            corporate_name: subfield_value(field, 'a', clean: true),
            subordinate_units: subfield_values(field, 'b'),
            meeting_locations: subfield_values(field, 'c'),
            meeting_dates: subfield_values(field, 'd'),
            relator_terms: subfield_values(field, 'e'),
            work_date: field['f'],
            misc_infos: subfield_values(field, 'g'),
            medium: field['h'],
            form_subheadings: subfield_values(field, 'k'),
            work_language: field['l'],
            music_performance_mediums: subfield_values(field, 'm'),
            part_numbers: subfield_values(field, 'n'),
            music_arranged_statement: field['o'],
            part_names: subfield_values(field, 'p'),
            music_key: field['r'],
            versions: subfield_values(field, 's'),
            work_title: field['t'],
            # No affiliation: field['u'],
            form_subdivisions: subfield_values(field, 'v'),
            general_subdivisions: subfield_values(field, 'x'),
            chronological_subdivisions: subfield_values(field, 'y'),
            geographic_subdivisions: subfield_values(field, 'z'),
            authority_record_control_numbers: [uri],
            # No uri: field['1'],
            # No heading_source: field['2'],
            # No materials_specified: field['3'],
            # No relationship: subfield_values(field, '4'),
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
