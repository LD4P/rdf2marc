# frozen_string_literal: true

require 'rdf2marc/model2marc/fields_shared_examples'

RSpec.describe Rdf2marc::Model2marc::Field242 do
  let(:model) do
    {
      title_fields: {
        translated_titles: [
          {
            added_entry: 'added',
            nonfile_characters: 0,
            title: 'title1',
            remainder_of_title: 'remainder1',
            part_names: %w[part_name1 part_name2],
            part_numbers: %w[part_numbers1 part_numbers2]
          },
          {
            added_entry: 'no_added',
            nonfile_characters: 5,
            title: 'title2'
          }
        ]
      }
    }
  end

  let(:expected_fields) do
    [
      '242 10 $a title1 $b remainder1 $n part_numbers1 $n part_numbers2 $p part_name1 $p part_name2',
      '242 05 $a title2'
    ]
  end

  include_examples 'fields', '242'
end
