# frozen_string_literal: true

require 'rdf2marc/model2marc/fields_shared_examples'

RSpec.describe Rdf2marc::Model2marc::Field655 do
  let(:model) do
    {
      subject_access_fields: {
        genre_forms: [
          {
            thesaurus: 'not_specified',
            genre_form_data: 'genre_form_data1',
            form_subdivisions: %w[form_subdivision1 form_subdivision2],
            general_subdivisions: %w[general_subdivision1 general_subdivision2],
            chronological_subdivisions: %w[chronological_subdivision1 chronological_subdivision2],
            geographic_subdivisions: %w[geographic_subdivision1 geographic_subdivision2],
            authority_record_control_numbers: %w[control_number1 control_number2],
            uris: %w[uri1 uri2],
            term_source: 'heading_source1',
            materials_specified: 'materials_specified1',
            applies_to_institution: 'institution1',
            linkage: 'linkage1',
            field_links: %w[field_link1 field_link2]
          },
          {
            thesaurus: 'lcsh',
            genre_form_data: 'genre_form_data1'
          }
        ]
      }
    }
  end

  let(:expected_fields) do
    [
      '655  4 $a genre_form_data1 $v form_subdivision1 $v form_subdivision2 $x general_subdivision1 $x general_subdivision2 $y chronological_subdivision1 $y chronological_subdivision2 $z geographic_subdivision1 $z geographic_subdivision2 $0 control_number1 $0 control_number2 $1 uri1 $1 uri2 $2 heading_source1 $3 materials_specified1 $5 institution1 $6 linkage1 $8 field_link1 $8 field_link2',
      '655  0 $a genre_form_data1'
    ]
  end

  include_examples 'fields', '655'
end
