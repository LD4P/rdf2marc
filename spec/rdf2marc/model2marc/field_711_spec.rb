# frozen_string_literal: true

RSpec.describe Rdf2marc::Model2marc::Field711 do
  let(:model) do
    {
      added_entry_fields: {
        meeting_names: [
          {
            type: 'direct',
            meeting_name: 'meeting_name1',
            meeting_locations: %w[meeting_location1 meeting_location2],
            meeting_dates: %w[meeting_date1 meeting_date2],
            subordinate_units: %w[subordinate_unit1 subordinate_unit2],
            work_date: 'work_date1',
            misc_infos: %w[misc_info1 misc_info2],
            medium: 'medium1',
            relator_terms: %w[term1 term2],
            form_subheadings: %w[form_subheading1 form_subheading2],
            work_language: 'work_language1',
            part_numbers: %w[part_number1 part_number2],
            part_names: %w[part_name1 part_name2],
            following_meeting_name: 'following_meeting_name1',
            versions: %w[version1 version2],
            work_title: 'work_title1',
            affiliation: 'affiliation1',
            issn: 'issn1',
            authority_record_control_numbers: %w[control_number1 control_number2],
            uris: %w[uri1 uri2],
            heading_source: 'heading_source1',
            relationships: %w[relationship1 relationship2],
            linkage: 'linkage1',
            field_links: %w[field_link1 field_link2]
          },
          {
            type: 'inverted',
            meeting_name: 'meeting_name2'
          }
        ]
      }
    }
  end

  let(:expected_fields) do
    [
      '711 2  $a meeting_name1 $c meeting_location1 $c meeting_location2 $d meeting_date1 $d meeting_date2 $e subordinate_unit1 $e subordinate_unit2 $f work_date1 $g misc_info1 $g misc_info2 $h medium1 $j term1 $j term2 $k form_subheading1 $k form_subheading2 $l work_language1 $n part_number1 $n part_number2 $p part_name1 $p part_name2 $q following_meeting_name1 $s version1 $s version2 $t work_title1 $u affiliation1 $x issn1 $0 control_number1 $0 control_number2 $1 uri1 $1 uri2 $2 heading_source1 $4 relationship1 $4 relationship2 $6 linkage1 $8 field_link1 $8 field_link2',
      '711 0  $a meeting_name2'
    ]
  end

  include_examples 'fields', '711'
end
