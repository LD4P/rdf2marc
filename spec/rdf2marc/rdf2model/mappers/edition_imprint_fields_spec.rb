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
    let(:ttl) do
      <<~TTL
                <#{instance_term}> <http://id.loc.gov/ontologies/bibframe/provisionActivity> _:b11 .
        _:b11 <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> <http://id.loc.gov/ontologies/bibframe/Publication> .
        _:b11 <http://id.loc.gov/ontologies/bibframe/place> <http://id.loc.gov/authorities/names/n82070796> .
        <http://id.loc.gov/authorities/names/n82070796> <http://www.w3.org/2000/01/rdf-schema#label> "Freehold (N.J.)" .
        _:b11 <http://id.loc.gov/ontologies/bibframe/agent> <http://id.loc.gov/authorities/names/n82158730> .
        <http://id.loc.gov/authorities/names/n82158730> <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> <http://id.loc.gov/ontologies/bibframe/Agent> .
        <http://id.loc.gov/authorities/names/n82158730> <http://www.w3.org/2000/01/rdf-schema#label> "ABC-Clio Information Services" .
        <http://id.loc.gov/authorities/names/n82158730> <http://id.loc.gov/ontologies/bibframe/role> <http://id.loc.gov/vocabulary/relators/pbl> .
        <http://id.loc.gov/vocabulary/relators/pbl> <http://www.w3.org/2000/01/rdf-schema#label> "Publisher" .
        _:b11 <http://id.loc.gov/ontologies/bibframe/date> "2020"@eng .
        <#{instance_term}> <http://id.loc.gov/ontologies/bibframe/provisionActivity> _:b13 .
        _:b13 <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> <http://id.loc.gov/ontologies/bibframe/Distribution> .
        _:b13 <http://id.loc.gov/ontologies/bibframe/place> <http://id.loc.gov/authorities/names/n00068607> .
        <http://id.loc.gov/authorities/names/n00068607> <http://www.w3.org/2000/01/rdf-schema#label> "West Seattle (Wash.)" .
        _:b13 <http://id.loc.gov/ontologies/bibframe/agent> <http://id.loc.gov/authorities/names/no2003107987> .
        <http://id.loc.gov/authorities/names/no2003107987> <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> <http://id.loc.gov/ontologies/bibframe/Agent> .
        <http://id.loc.gov/authorities/names/no2003107987> <http://www.w3.org/2000/01/rdf-schema#label> "Wood and Iverson Lumber Company" .
        _:b13 <http://id.loc.gov/ontologies/bibframe/date> "2019"@eng .
        <#{instance_term}> <http://id.loc.gov/ontologies/bibframe/provisionActivity> _:b15 .
        _:b15 <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> <http://id.loc.gov/ontologies/bibframe/Manufacture> .
        _:b15 <http://id.loc.gov/ontologies/bibframe/place> <http://id.loc.gov/authorities/names/n79061258> .
        <http://id.loc.gov/authorities/names/n79061258> <http://www.w3.org/2000/01/rdf-schema#label> "Cambridge (Mass.)" .
        _:b15 <http://id.loc.gov/ontologies/bibframe/agent> <http://id.loc.gov/authorities/names/nr92038535> .
        <http://id.loc.gov/authorities/names/nr92038535> <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> <http://id.loc.gov/ontologies/bibframe/Agent> .
        <http://id.loc.gov/authorities/names/nr92038535> <http://www.w3.org/2000/01/rdf-schema#label> "Cambridge Press (Cambridge, Mass.)" .
        _:b15 <http://id.loc.gov/ontologies/bibframe/date> "2017"@eng .
      TTL
    end

    let(:model) do
      {
        publication_distributions: [
          {
            entity_function: 'publication',
            publication_distribution_places: ['Freehold (N.J.)'],
            publisher_distributor_names: ['ABC-Clio Information Services'],
            publication_distribution_dates: ['2020']
          },
          {
            entity_function: 'publication',
            publication_distribution_places: ['West Seattle (Wash.)'],
            publisher_distributor_names: ['Wood and Iverson Lumber Company'],
            publication_distribution_dates: ['2019']
          },
          {
            entity_function: 'manufacture',
            publication_distribution_places: ['Cambridge (Mass.)'],
            publisher_distributor_names: ['Cambridge Press (Cambridge, Mass.)'],
            publication_distribution_dates: ['2017']
          }
        ]
      }
    end

    include_examples 'mapper', described_class
  end
end
