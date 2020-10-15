# frozen_string_literal: true

require 'rdf2marc/model2marc/fields_shared_examples'

RSpec.describe Rdf2marc::Model2marc::Field336 do
  let(:model) do
    {
      physical_description_fields: {
        content_types: [
          {
            content_type_terms: %w[term1 term2],
            content_type_codes: %w[code1 code2],
            authority_control_number_uri: 'uri',
            source: 'source1'
          },
          {
            content_type_terms: ['term3']
          }
        ]
      }
    }
  end

  let(:expected_fields) do
    [
      '336    $a term1 $a term2 $c code1 $c code2 $0 uri $2 source1',
      '336    $a term3 $2 rdacontent'
    ]
  end

  include_examples 'fields', '336'
end
