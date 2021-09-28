# frozen_string_literal: true

RSpec.describe Rdf2marc::Model2marc::Field650 do
  let(:model) do
    {
      subject_access_fields: {
        topical_terms: [
          {
            thesaurus: 'lcsh',
            uris: %w[uri1]
          },
          {
            subject_level: 'not_specified',
            thesaurus: 'not_specified',
            topical_term_or_geo_name: 'topical_term1',
            topical_term_following_geo_name: 'topical_term2',
            event_location: 'event_location1',
            dates: 'date1',
            relator_terms: %w[term1 term2],
            misc_infos: %w[misc_info1 misc_info2],
            form_subdivisions: %w[form_subdivision1 form_subdivision2],
            general_subdivisions: %w[general_subdivision1 general_subdivision2],
            chronological_subdivisions: %w[chronological_subdivision1 chronological_subdivision2],
            geographic_subdivisions: %w[geographic_subdivision1 geographic_subdivision2],
            authority_record_control_numbers: %w[control_number1 control_number2],
            uris: %w[uri1 uri2],
            heading_source: 'heading_source1',
            materials_specified: 'materials_specified',
            linkage: 'linkage1',
            field_links: %w[field_link1 field_link2]
          },
          {
            subject_level: 'secondary',
            thesaurus: 'lcsh',
            topical_term_or_geo_name: 'topical_term3'
          }
        ]
      }
    }
  end

  let(:expected_fields) do
    [
      '650  0 $1 uri1',
      '650 04 $a topical_term1 $b topical_term2 $c event_location1 $d date1 $e term1 $e term2 $g misc_info1 $g misc_info2 $v form_subdivision1 $v form_subdivision2 $x general_subdivision1 $x general_subdivision2 $y chronological_subdivision1 $y chronological_subdivision2 $z geographic_subdivision1 $z geographic_subdivision2 $2 heading_source1 $0 control_number1 $0 control_number2 $1 uri1 $1 uri2 $3 materials_specified $6 linkage1 $8 field_link1 $8 field_link2',
      '650 20 $a topical_term3'
    ]
  end

  include_examples 'fields', '650'
end
