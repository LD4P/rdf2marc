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
        <#{work_term}> <http://id.loc.gov/ontologies/bibframe/note> _:b1;
          <http://id.loc.gov/ontologies/bibframe/tableOfContents> _:b3.
        _:b1 a <http://id.loc.gov/ontologies/bibframe/Note>;
          <http://www.w3.org/2000/01/rdf-schema#label> "Recast in bronze from artist's plaster original of 1903."@eng.
        <#{instance_term}> <http://id.loc.gov/ontologies/bibframe/note> _:b2;
          <http://id.loc.gov/ontologies/bibframe/provisionActivityStatement> "provision activity statement!"@eng.
        _:b2 a <http://id.loc.gov/ontologies/bibframe/Note>;
          <http://www.w3.org/2000/01/rdf-schema#label> "Translated from German."@eng.
        _:b3 a <http://id.loc.gov/ontologies/bibframe/TableOfContents>;
          <http://www.w3.org/2000/01/rdf-schema#label> "Introduction : the philosopher's stone -- The field atlas :maps and meaning across California's forests"@eng.
      TTL
    end
    let(:toc) do
      "Introduction : the philosopher's stone -- The field atlas :maps and meaning across California's forests"
    end

    let(:model) do
      {
        general_notes: [
          {
            general_note: "Recast in bronze from artist's plaster original of 1903."
          },
          {
            general_note: 'Translated from German.'
          },
          {
            general_note: 'Transcribed publication statement: provision activity statement!'
          }
        ],
        table_of_contents: [toc]
      }
    end

    include_examples 'mapper', described_class
  end
end
