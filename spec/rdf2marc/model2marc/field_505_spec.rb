# frozen_string_literal: true

RSpec.describe Rdf2marc::Model2marc::Field505 do
  let(:model) do
    {
      note_fields: {
        table_of_contents: %w[
          one two
        ]
      }
    }
  end

  let(:expected_fields) do
    [
      '505 0  $a one',
      '505 0  $a two'
    ]
  end

  include_examples 'fields', '505'
end
