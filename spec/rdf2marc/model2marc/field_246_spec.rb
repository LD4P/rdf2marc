# frozen_string_literal: true

require 'rdf2marc/model2marc/fields_shared_examples'

RSpec.describe Rdf2marc::Model2marc::Field246 do
  let(:model) do
    {
      title_fields: {
        variant_titles: [
          {
            note_added_entry: 'note_added',
            type: 'none',
            title: 'title1',
            remainder_of_title: 'remainder1',
            part_names: %w[part_name1 part_name2],
            part_numbers: %w[part_numbers1 part_numbers2]
          },
          {
            note_added_entry: 'note_no_added',
            type: 'portion',
            title: 'title2'
          }
        ]
      }
    }
  end

  let(:expected_fields) do
    [
      '246 1  $a title1 $b remainder1 $n part_numbers1 $n part_numbers2 $p part_name1 $p part_name2',
      '246 00 $a title2'
    ]
  end

  include_examples 'fields', '246'
end
