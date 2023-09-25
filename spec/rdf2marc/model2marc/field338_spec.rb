# frozen_string_literal: true

RSpec.describe Rdf2marc::Model2marc::Field338 do
  let(:model) do
    {
      physical_description_fields: {
        carrier_types: [
          {
            carrier_type_terms: %w[term1 term2],
            carrier_type_codes: %w[code1 code2],
            authority_control_number_uri: 'uri',
            source: 'source1'
          },
          {
            carrier_type_terms: ['term3']
          }
        ]
      }
    }
  end

  let(:expected_fields) do
    [
      '338    $a term1 $a term2 $b code1 $b code2 $0 uri $2 source1',
      '338    $a term3 $2 rdacarrier'
    ]
  end

  include_examples 'fields', '338'
end
