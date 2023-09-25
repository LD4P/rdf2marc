# frozen_string_literal: true

RSpec.describe Rdf2marc::Model2marc::Field300 do
  context 'with multiple extents and dimensions in single physical description' do
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

  context 'with single extents and dimensions in multiple physical descriptions' do
    let(:model) do
      {
        physical_description_fields: {
          physical_descriptions: [
            {
              extents: %w[extent1],
              dimensions: %w[dimension1 dimensionA],
              materials_specified: 'materials_specified1'
            },
            {
              extents: %w[extent2 extent3],
              dimensions: %w[dimension2],
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
        '300    $a extent1 $c dimension1 $c dimensionA $3 materials_specified1',
        '300    $a extent2 $a extent3 $c dimension2 $3 materials_specified1',
        '300    $3 materials_specified2'
      ]
    end

    include_examples 'fields', '300'
  end

  context 'with other_physical_details physical descriptions' do
    let(:model) do
      {
        physical_description_fields: {
          physical_descriptions: [
            {
              extents: %w[extent1],
              other_physical_details: 'Illustrations',
              dimensions: %w[dimension1]
            }
          ]
        }
      }
    end

    let(:expected_fields) do
      [
        '300    $a extent1 $b Illustrations $c dimension1'
      ]
    end

    include_examples 'fields', '300'
  end
end
