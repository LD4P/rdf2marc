# frozen_string_literal: true

require 'rdf2marc/model2marc/fields_shared_examples'

RSpec.describe Rdf2marc::Model2marc::Field490 do
  let(:model) do
    {
      series_statement_fields: {
        series_statements: [
          {
            tracing_policy: 'not_traced',
            series_statements: %w[statement1 statement2]
          },
          {
            tracing_policy: 'traced',
            series_statements: ['statement3']
          }
        ]
      }
    }
  end

  let(:expected_fields) do
    [
      '490 0  $a statement1 $a statement2',
      '490 1  $a statement3'
    ]
  end

  include_examples 'fields', '490'
end
