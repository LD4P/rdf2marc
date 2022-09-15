# frozen_string_literal: true

RSpec.describe Rdf2marc::Model2marc::Field647 do
  let(:model) do
    {
      subject_access_fields: {
        event_names: [
          {
            thesaurus: 'subfield2',
            source: 'fast',
            name: 'World War (1939-1945)--Sounds',
            authority_record_control_numbers: ['http://id.worldcat.org/fast/1181267']
          },
          {
            thesaurus: 'lcsh',
            name: 'event_name1',
            locations: %w[event_location1 event_location2],
            date: 'date1',
            misc_infos: %w[misc_info1 misc_info2],
            form_subdivisions: %w[form_subdivision1 form_subdivision2],
            general_subdivisions: %w[general_subdivision1 general_subdivision2],
            chronological_subdivisions: %w[chronological_subdivision1 chronological_subdivision2],
            geographic_subdivisions: %w[geographic_subdivision1 geographic_subdivision2],
            authority_record_control_numbers: %w[control_number1 control_number2],
            uris: %w[uri1 uri2],
            source: 'source1',
            materials_specified: 'materials_specified',
            linkage: 'linkage1',
            field_links: %w[field_link1 field_link2]
          }

        ]
      }
    }
  end

  let(:expected_fields) do
    [
      '647  7 $a World War (1939-1945)--Sounds $0 http://id.worldcat.org/fast/1181267 $2 fast',
      '647  0 $a event_name1 $c event_location1 $c event_location2 $d date1 $g misc_info1 $g misc_info2 $v form_subdivision1 $v form_subdivision2 $x general_subdivision1 $x general_subdivision2 $y chronological_subdivision1 $y chronological_subdivision2 $z geographic_subdivision1 $z geographic_subdivision2 $0 control_number1 $0 control_number2 $1 uri1 $1 uri2 $2 source1 $3 materials_specified $6 linkage1 $8 field_link1 $8 field_link2'
    ]
  end

  include_examples 'fields', '647'
end
