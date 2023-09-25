# frozen_string_literal: true

RSpec.describe Rdf2marc::Model2marc::Field247 do
  let(:model) do
    {
      title_fields: {
        former_titles: [
          {
            added_entry: 'added',
            note_controller: 'no_display',
            title: 'title1',
            remainder_of_title: 'remainder1',
            part_names: %w[part_name1 part_name2],
            part_numbers: %w[part_numbers1 part_numbers2]
          },
          {
            added_entry: 'no_added',
            note_controller: 'display',
            title: 'title2'
          }
        ]
      }
    }
  end

  let(:expected_fields) do
    [
      '247 11 $a title1 $b remainder1 $n part_numbers1 $n part_numbers2 $p part_name1 $p part_name2',
      '247 00 $a title2'
    ]
  end

  include_examples 'fields', '247'
end
