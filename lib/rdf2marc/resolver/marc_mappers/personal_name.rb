# frozen_string_literal: true

module Rdf2marc
  module Resolver
    module MarcMappers
      # Mapper for personal names.
      class PersonalName < BaseMapper
        def map
          field = marc_record['100']
          {
            type: personal_name_type_for(field.indicator1),
            personal_name: subfield_value(field, 'a', clean: true),
            numeration: field['b'],
            title_and_words: subfield_values(field, 'c'),
            dates: field['d'],
            relator_terms: subfield_values(field, 'e'),
            work_date: field['f'],
            misc_infos: subfield_values(field, 'g'),
            medium: field['h'],
            attribution_qualifiers: subfield_values(field, 'j'),
            form_subheadings: subfield_values(field, 'k'),
            work_language: field['l'],
            music_performance_mediums: subfield_values(field, 'm'),
            part_numbers: subfield_values(field, 'n'),
            music_arranged_statement: field['o'],
            part_names: subfield_values(field, 'p'),
            fuller_form: field['q'],
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
            # No source: field['2'],
            # No materials_specified: field['3'],
            # No relationships: subfield_values(field, '4'),
            linkage: field['6'],
            field_links: subfield_values(field, '8')
          }
        end

        private

        def personal_name_type_for(indicator1)
          case indicator1
          when '0'
            'forename'
          when '1'
            'surname'
          else
            'family_name'
          end
        end
      end
    end
  end
end
