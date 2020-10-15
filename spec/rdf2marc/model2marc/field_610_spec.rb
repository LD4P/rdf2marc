# frozen_string_literal: true

require 'rdf2marc/model2marc/fields_shared_examples'

RSpec.describe Rdf2marc::Model2marc::Field610 do
  let(:model) do
    {
      subject_access_fields: {
        corporate_names: [
          {
            type: 'direct',
            corporate_name: 'corporate_name1',
            subordinate_units: %w[subordinate_unit1 subordinate_unit2],
            meeting_locations: %w[meeting_location1 meeting_location2],
            meeting_dates: %w[meeting_date1 meeting_date2],
            relator_terms: %w[relator_term1 relator_term2],
            work_date: 'work_date1',
            misc_infos: %w[misc_info1 misc_info2],
            versions: %w[version1 version2],
            form_subheadings: %w[form_subheading1 form_subheading2],
            work_language: 'work_language1',
            music_performance_mediums: %w[medium1 medium2],
            part_numbers: %w[part_number1 part_number2],
            music_arranged_statement: 'statement1',
            part_names: %w[part_name1 part_name2],
            music_key: 'music_key',
            work_title: 'work_title1',
            affiliation: 'affiliation1',
            authority_record_control_numbers: %w[control_number1 control_number2],
            uris: %w[uri1 uri2],
            heading_source: 'heading_source1',
            materials_specified: 'materials_specified',
            relationships: %w[relationship1 relationship2],
            form_subdivisions: %w[form_subdivision1 form_subdivision2],
            general_subdivisions: %w[general_subdivision1 general_subdivision2],
            chronological_subdivisions: %w[chronological_subdivision1 chronological_subdivision2],
            geographic_subdivisions: %w[geographic_subdivision1 geographic_subdivision2],
            linkage: 'linkage1',
            field_links: %w[field_link1 field_link2]
          },
          {
            type: 'inverted',
            corporate_name: 'corporate_name2'
          }
        ]
      }
    }
  end

  let(:expected_fields) do
    [
      '610 2  $a corporate_name1 $b subordinate_unit1 $b subordinate_unit2 $c meeting_location1 $c meeting_location2 $d meeting_date1 $d meeting_date2 $e relator_term1 $e relator_term2 $f work_date1 $g misc_info1 $g misc_info2 $h version1 $h version2 $k form_subheading1 $k form_subheading2 $l work_language1 $m medium1 $m medium2 $n part_number1 $n part_number2 $o statement1 $p part_name1 $p part_name2 $r music_key $t work_title1 $u affiliation1 $v form_subdivision1 $v form_subdivision2 $x general_subdivision1 $x general_subdivision2 $y chronological_subdivision1 $y chronological_subdivision2 $z geographic_subdivision1 $z geographic_subdivision2 $0 control_number1 $0 control_number2 $1 uri1 $1 uri2 $2 heading_source1 $3 materials_specified $4 relationship1 $4 relationship2 $6 linkage1 $8 field_link1 $8 field_link2',
      '610 0  $a corporate_name2'
    ]
  end

  include_examples 'fields', '610'
end
