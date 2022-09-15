# frozen_string_literal: true

RSpec.describe Rdf2marc::Model2marc::Field700 do
  let(:model) do
    {
      added_entry_fields: {
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
            relationship_info: %w[info1 info2],
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
            issn: 'issn1',
            authority_record_control_numbers: %w[control_number1 control_number2],
            uris: %w[uri1 uri2],
            source: 'source1',
            materials_specified: 'materials_specified',
            relationships: %w[relationship1 relationship2],
            institution_applies_to: 'institution1',
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
      '700 1  $a personal_name1 $b numeration1 $c title_and_word01 $c title_and_word2 $d dates1 $e relator_term1 $e relator_term2 $f work_date1 $g misc_info1 $g misc_info2 $h version1 $h version2 $i info1 $i info2 $j qualifier1 $j qualifier2 $k form_subheading1 $k form_subheading2 $l work_language1 $m medium1 $m medium2 $n part_number1 $n part_number2 $o statement1 $p part_name1 $p part_name2 $q fuller_form1 $r music_key $t work_title1 $u affiliation1 $x issn1 $0 control_number1 $0 control_number2 $1 uri1 $1 uri2 $2 source1 $3 materials_specified $4 relationship1 $4 relationship2 $5 institution1 $6 linkage1 $8 field_link1 $8 field_link2',
      '700 0  $a personal_name2'
    ]
  end

  include_examples 'fields', '700'
end
