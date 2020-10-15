# frozen_string_literal: true

require 'rdf2marc/model2marc/fields_shared_examples'

RSpec.describe Rdf2marc::Model2marc::Field651 do
  let(:model) do
    {
      subject_access_fields: {
        geographic_names: [
          {
            geographic_name: 'geographic_name1',
            form_subdivisions: %w[form_subdivision1 form_subdivision2],
            general_subdivisions: %w[general_subdivision1 general_subdivision2],
            chronological_subdivisions: %w[chronological_subdivision1 chronological_subdivision2],
            geographic_subdivisions: %w[geographic_subdivision1 geographic_subdivision2],
            authority_record_control_numbers: %w[control_number1 control_number2],
            uris: %w[uri1 uri2],
            source: 'source1',
            materials_specified: 'materials_specified1',
            linkage: 'linkage1',
            field_links: %w[field_link1 field_link2]
          },
          {
            geographic_name: 'geographic_name2'
          }
        ]
      }
    }
  end

  let(:expected_fields) do
    [
      '651    $a geographic_name1 $v form_subdivision1 $v form_subdivision2 $x general_subdivision1 $x general_subdivision2 $y chronological_subdivision1 $y chronological_subdivision2 $z geographic_subdivision1 $z geographic_subdivision2 $0 control_number1 $0 control_number2 $1 uri1 $1 uri2 $2 source1 $3 materials_specified1 $6 linkage1 $8 field_link1 $8 field_link2',
      '651    $a geographic_name2'
    ]
  end

  include_examples 'fields', '651'
end
