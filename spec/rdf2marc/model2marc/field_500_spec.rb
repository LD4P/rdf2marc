# frozen_string_literal: true

require 'rdf2marc/model2marc/fields_shared_examples'

RSpec.describe Rdf2marc::Model2marc::Field500 do
  let(:model) do
    {
      note_fields: {
        general_notes: [
          {
            general_note: 'note1'
          },
          {
            general_note: 'note2'
          }
        ]
      }
    }
  end

  let(:expected_fields) do
    [
      '500    $a note1',
      '500    $a note2'
    ]
  end

  include_examples 'fields', '500'
end
