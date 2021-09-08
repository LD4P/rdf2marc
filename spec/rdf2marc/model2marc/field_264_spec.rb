# frozen_string_literal: true

RSpec.describe Rdf2marc::Model2marc::Field264 do
  let(:model) do
    {
      edition_imprint_fields: {
        publication_distributions: [
          {
            entity_function: 'publication',
            publication_distribution_places: %w[place1 place2],
            publisher_distributor_names: %w[name1 name2],
            publication_distribution_dates: %w[date1 date2]
          },
          entity_function: 'production',
          publisher_distributor_names: %w[name3 name4]
        ]
      }
    }
  end

  let(:expected_fields) do
    [
      '264  1 $a place1 $a place2 $b name1 $b name2 $c date1 $c date2',
      '264  0 $b name3 $b name4'
    ]
  end

  include_examples 'fields', '264'
end
