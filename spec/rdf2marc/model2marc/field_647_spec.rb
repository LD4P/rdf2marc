# frozen_string_literal: true

RSpec.describe Rdf2marc::Model2marc::Field647 do
  let(:model) do
    {
      subject_access_fields: {
        event_names: [
          {
            thesaurus: 'subfield2',
            source: 'fast',
            name: 'World War (1939-1945)--Sounds',
            uris: ['http://id.worldcat.org/fast/1181267']
          }
        ]
      }
    }
  end

  let(:expected_fields) do
    [
      '647  7 $a World War (1939-1945)--Sounds $2 fast $0 http://id.worldcat.org/fast/1181267'
    ]
  end

  include_examples 'fields', '647'
end
