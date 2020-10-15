# frozen_string_literal: true

require 'rdf2marc/rdf2model/mappers/mappers_shared_examples'

RSpec.describe Rdf2marc::Rdf2model::Mappers::NoteFields do
  context 'with minimal graph' do
    let(:ttl) { '' }

    let(:model) do
      {}
    end

    include_examples 'mapper', described_class
  end

  describe 'general notes' do
    let(:ttl) do
      <<~TTL
                          <#{work_term}> <http://id.loc.gov/ontologies/bibframe/note> _:b1.
            _:b1 a <http://id.loc.gov/ontologies/bibframe/Note>;
        <http://www.w3.org/2000/01/rdf-schema#label> "Recast in bronze from artist's plaster original of 1903."@eng.
                          <#{instance_term}> <http://id.loc.gov/ontologies/bibframe/note> _:b2.
            _:b2 a <http://id.loc.gov/ontologies/bibframe/Note>;
        <http://www.w3.org/2000/01/rdf-schema#label> "Translated from German."@eng.
      TTL
    end

    let(:model) do
      {
        general_notes: [
          {
            general_note: "Recast in bronze from artist's plaster original of 1903."
          },
          {
            general_note: 'Translated from German.'
          }
        ]
      }
    end
    include_examples 'mapper', described_class
  end
end
