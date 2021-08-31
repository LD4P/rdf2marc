# frozen_string_literal: true

require 'rdf2marc/rdf2model/mappers/mappers_shared_examples'

RSpec.describe Rdf2marc::Rdf2model::Mappers::Leader do
  context 'when mapping minimal graph' do
    let(:ttl) { '' }

    let(:model) do
      {
        bibliographic_level: 'item',
        type: 'language_material'
      }
    end

    include_examples 'mapper', described_class
  end

  describe 'record status' do
    let(:ttl) do
      <<~TTL
                          <#{admin_metadata_term}> <http://id.loc.gov/ontologies/bibframe/status> _:b17.
        _:b17 a <http://id.loc.gov/ontologies/bibframe/Status>;
            <http://id.loc.gov/ontologies/bibframe/code> "a"@eng.
      TTL
    end

    let(:model) do
      {
        bibliographic_level: 'item',
        type: 'language_material',
        record_status: 'a'
      }
    end

    include_examples 'mapper', described_class
  end

  describe 'type' do
    let(:ttl) do
      <<~TTL
        <#{instance_term}> <http://sinopia.io/vocabulary/hasResourceTemplate> "ld4p:RT:bf2:Cartographic:Instance".
      TTL
    end

    let(:model) do
      {
        bibliographic_level: 'item',
        type: 'cartographic'
      }
    end

    include_examples 'mapper', described_class
  end

  describe 'bibliographic level' do
    let(:ttl) do
      <<~TTL
        <#{instance_term}> <http://id.loc.gov/ontologies/bibframe/issuance> <http://id.loc.gov/vocabulary/issuance/serl> .
        <http://id.loc.gov/vocabulary/issuance/serl> <http://www.w3.org/2000/01/rdf-schema#label> "serial" .
      TTL
    end

    let(:model) do
      {
        bibliographic_level: 'serial',
        type: 'language_material'
      }
    end

    include_examples 'mapper', described_class
  end

  describe 'encoding level' do
    let(:ttl) do
      <<~TTL
        <#{admin_metadata_term}> <http://id.loc.gov/ontologies/bflc/encodingLevel> <http://id.loc.gov/vocabulary/menclvl/f>.
        <http://id.loc.gov/vocabulary/menclvl/f> <http://www.w3.org/2000/01/rdf-schema#label> "full".
      TTL
    end

    let(:model) do
      {
        bibliographic_level: 'item',
        type: 'language_material',
        encoding_level: 'full'
      }
    end

    include_examples 'mapper', described_class
  end

  describe 'description conventions' do
    let(:ttl) do
      <<~TTL
        <#{admin_metadata_term}> <http://id.loc.gov/ontologies/bibframe/descriptionConventions> <http://id.loc.gov/vocabulary/descriptionConventions/isbd>.
        <http://id.loc.gov/vocabulary/descriptionConventions/isbd> <http://www.w3.org/2000/01/rdf-schema#label> "ISBD: International Standard Bibliographic Description".
        <#{admin_metadata_term}> <http://id.loc.gov/ontologies/bibframe/descriptionConventions> <http://id.loc.gov/vocabulary/descriptionConventions/aacr>.
        <http://id.loc.gov/vocabulary/descriptionConventions/aacr> <http://www.w3.org/2000/01/rdf-schema#label> "Anglo-American cataloguing rules".
      TTL
    end

    let(:model) do
      {
        bibliographic_level: 'item',
        type: 'language_material',
        cataloging_form: 'aacr2'
      }
    end

    include_examples 'mapper', described_class
  end
end
