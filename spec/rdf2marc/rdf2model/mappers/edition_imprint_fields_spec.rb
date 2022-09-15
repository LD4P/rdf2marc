# frozen_string_literal: true

require 'rdf2marc/rdf2model/mappers/mappers_shared_examples'

RSpec.describe Rdf2marc::Rdf2model::Mappers::EditionImprintFields, :vcr do
  context 'with minimal graph' do
    let(:ttl) { '' }

    let(:model) { {} }

    include_examples 'mapper', described_class
  end

  describe 'editions' do
    let(:ttl) do
      <<~TTL
        <#{instance_term}> <http://id.loc.gov/ontologies/bibframe/editionStatement> "Third edition."@eng, "Canadian edition."@eng .
      TTL
    end

    let(:model) do
      {
        editions: [{ edition: 'Canadian edition.' }, { edition: 'Third edition.' }]
      }
    end

    include_examples 'mapper', described_class
  end

  describe 'publication_distributions' do
    let(:model) do
      {
        publication_distributions: [
          {
            entity_function: 'publication',
            publication_distribution_places: ['Freehold (N.J.)'],
            publisher_distributor_names: ['ABC-Clio Information Services'],
            publication_distribution_dates: ['[2020]']
          },
          {
            entity_function: 'distribution',
            publication_distribution_places: ['West Seattle (Wash.)'],
            publisher_distributor_names: ['Wood and Iverson Lumber Company'],
            publication_distribution_dates: ['[2019]']
          },
          {
            entity_function: 'manufacture',
            publication_distribution_places: ['Cambridge (Mass.)'],
            publisher_distributor_names: ['Cambridge Press (Cambridge, Mass.)'],
            publication_distribution_dates: ['[2017]']
          }
        ]
      }
    end
    let(:ttl) do
      <<~TTL
                <#{instance_term}> <http://id.loc.gov/ontologies/bibframe/provisionActivity> _:b11 .
        _:b11 <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> <http://id.loc.gov/ontologies/bibframe/Publication> .
        _:b11 <http://id.loc.gov/ontologies/bflc/simplePlace> "Freehold (N.J.)"@eng .
        _:b11 <http://id.loc.gov/ontologies/bflc/simpleAgent> "ABC-Clio Information Services"@eng .
        _:b11 <http://id.loc.gov/ontologies/bflc/simpleDate> "[2020]"@en.
        <#{instance_term}> <http://id.loc.gov/ontologies/bibframe/provisionActivity> _:b13 .
        _:b13 <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> <http://id.loc.gov/ontologies/bibframe/Distribution> .
        _:b13 <http://id.loc.gov/ontologies/bflc/simplePlace> "West Seattle (Wash.)"@eng .
        _:b13 <http://id.loc.gov/ontologies/bflc/simpleAgent> "Wood and Iverson Lumber Company"@eng .
        _:b13 <http://id.loc.gov/ontologies/bflc/simpleDate> "[2019]"@eng .
        <#{instance_term}> <http://id.loc.gov/ontologies/bibframe/provisionActivity> _:b15 .
        _:b15 <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> <http://id.loc.gov/ontologies/bibframe/Manufacture> .
        _:b15 <http://id.loc.gov/ontologies/bflc/simplePlace> "Cambridge (Mass.)"@eng .
        _:b15 <http://id.loc.gov/ontologies/bflc/simpleAgent> "Cambridge Press (Cambridge, Mass.)"@eng .
        _:b15 <http://id.loc.gov/ontologies/bflc/simpleDate> "[2017]"@eng .
      TTL
    end

    include_examples 'mapper', described_class
  end
end
