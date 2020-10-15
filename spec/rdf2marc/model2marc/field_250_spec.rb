# frozen_string_literal: true

require 'rdf2marc/model2marc/fields_shared_examples'

RSpec.describe Rdf2marc::Model2marc::Field250 do
  let(:model) do
    {
      edition_imprint_fields: {
        editions: [
          {
            edition: 'edition1'
          },
          {
            edition: 'edition2'
          }
        ]
      }
    }
  end

  let(:expected_fields) do
    [
      '250    $a edition1',
      '250    $a edition2'
    ]
  end

  include_examples 'fields', '250'
end
