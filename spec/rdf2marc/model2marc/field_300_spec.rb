# frozen_string_literal: true

RSpec.describe Rdf2marc::Model2marc::Field300 do
  let(:model) do
    {
      physical_description_fields: {
        physical_descriptions: [
          {
            extents: %w[extent1 extent2],
            dimensions: %w[dimension1 dimension2],
            materials_specified: 'materials_specified1'
          },
          {
            materials_specified: 'materials_specified2'
          }
        ]
      }
    }
  end

  let(:expected_fields) do
    [
      '300    $a extent1 $a extent2 $c dimension1 $c dimension2 $3 materials_specified1',
      '300    $3 materials_specified2'
    ]
  end

  include_examples 'fields', '300'
end
