# frozen_string_literal: true

RSpec.describe Rdf2marc::Model2marc::Field600 do
  let(:model) do
    {
      subject_access_fields: {
        personal_names: [
          {
            type: 'surname',
            personal_name: 'personal_name1',
            numeration: 'numeration1',
            title_and_words: %w[title_and_word01 title_and_word2],
            dates: 'dates1',
            relator_terms: %w[relator_term1 relator_term2],
            work_date: 'work_date1',
            misc_infos: %w[misc_info1 misc_info2],
            versions: %w[version1 version2],
            attribution_qualifiers: %w[qualifier1 qualifier2],
            form_subheadings: %w[form_subheading1 form_subheading2],
            work_language: 'work_language1',
            music_performance_mediums: %w[medium1 medium2],
            part_numbers: %w[part_number1 part_number2],
            music_arranged_statement: 'statement1',
            part_names: %w[part_name1 part_name2],
            fuller_form: 'fuller_form1',
            music_key: 'music_key',
            work_title: 'work_title1',
            affiliation: 'affiliation1',
            authority_record_control_numbers: %w[control_number1 control_number2],
            uris: %w[uri1 uri2],
            source: 'source1',
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
            type: 'forename',
            personal_name: 'personal_name2'
          }
        ]
      }
    }
  end

  let(:expected_fields) do
    [
      '600 1  $a personal_name1 $b numeration1 $c title_and_word01 $c title_and_word2 $d dates1 $e relator_term1 $e relator_term2 $f work_date1 $g misc_info1 $g misc_info2 $h version1 $h version2 $j qualifier1 $j qualifier2 $k form_subheading1 $k form_subheading2 $l work_language1 $m medium1 $m medium2 $n part_number1 $n part_number2 $o statement1 $p part_name1 $p part_name2 $q fuller_form1 $r music_key $t work_title1 $u affiliation1 $v form_subdivision1 $v form_subdivision2 $x general_subdivision1 $x general_subdivision2 $y chronological_subdivision1 $y chronological_subdivision2 $z geographic_subdivision1 $z geographic_subdivision2 $0 control_number1 $0 control_number2 $1 uri1 $1 uri2 $2 source1 $3 materials_specified $4 relationship1 $4 relationship2 $6 linkage1 $8 field_link1 $8 field_link2',
      '600 0  $a personal_name2'
    ]
  end

  include_examples 'fields', '600'
end
