# frozen_string_literal: true

RSpec.describe Rdf2marc::Model2marc::Field050 do
  let(:model) do
    {
      number_and_code_fields: {
        lc_call_numbers: [
          {
            assigned_by: 'lc',
            classification_numbers: %w[class_number1 class_number1],
            item_number: 'item_number1'
          },
          {
            assigned_by: 'other',
            classification_numbers: ['class_number3']
          }
        ]
      }
    }
  end

  let(:expected_fields) do
    [
      '050  0 $a class_number1 $a class_number1 $b item_number1',
      '050  4 $a class_number3'
    ]
  end

  include_examples 'fields', '050'
end
