# frozen_string_literal: true

RSpec.describe Rdf2marc::Model2marc::Field337 do
  let(:model) do
    {
      physical_description_fields: {
        media_types: [
          {
            media_type_terms: %w[term1 term2],
            media_type_codes: %w[code1 code2],
            authority_control_number_uri: 'uri',
            source: 'source1'
          },
          {
            media_type_terms: ['term3']
          }
        ]
      }
    }
  end

  let(:expected_fields) do
    [
      '337    $a term1 $a term2 $c code1 $c code2 $0 uri $2 source1',
      '337    $a term3 $2 rdamedia'
    ]
  end

  include_examples 'fields', '337'
end
