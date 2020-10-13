# frozen_string_literal: true

require 'rdf2marc/rdf2model/mappers/mappers_shared_examples'

RSpec.describe Rdf2marc::Rdf2model::Mappers::ControlFields, :vcr do
  context 'mapping minimal graph' do
    let(:ttl) { '' }

    let(:model) do
      {
        general_info: {}
      }
    end

    include_examples 'mapper', described_class
  end

  describe 'control number' do
    let(:ttl) do
      <<~TTL
                  <#{admin_metadata_term}> <http://id.loc.gov/ontologies/bibframe/identifiedBy> _:b7.
        _:b7 a <http://id.loc.gov/ontologies/bibframe/Local>;
            <http://www.w3.org/1999/02/22-rdf-syntax-ns#value> "abc123"@eng.
      TTL
    end

    let(:model) do
      {
        general_info: {},
        control_number: 'abc123'
      }
    end

    include_examples 'mapper', described_class
  end

  describe 'control number id' do
    let(:ttl) do
      <<~TTL
        <#{admin_metadata_term}> <http://id.loc.gov/ontologies/bibframe/source> <http://id.loc.gov/vocabulary/organizations/cst>, <http://id.loc.gov/vocabulary/organizations/nsfvsfl>.
      TTL
    end

    let(:model) do
      {
        general_info: {},
        control_number_id: 'cst'
      }
    end

    include_examples 'mapper', described_class
  end

  describe 'latest transaction' do
    let(:ttl) do
      <<~TTL
        <#{admin_metadata_term}> <http://id.loc.gov/ontologies/bibframe/changeDate> "2020-10-23"@eng.
      TTL
    end

    let(:model) do
      {
        general_info: {},
        latest_transaction: Date.new(2020, 10, 23)
      }
    end

    include_examples 'mapper', described_class
  end

  describe 'general info place' do
    let(:ttl) do
      <<~TTL
                  <#{instance_term}> <http://id.loc.gov/ontologies/bibframe/provisionActivity> _:b9.
        _:b9 a <http://id.loc.gov/ontologies/bibframe/Publication>;
            <http://id.loc.gov/ontologies/bibframe/place> <http://id.loc.gov/authorities/names/n78003886>.
        <http://id.loc.gov/authorities/names/n78003886> <http://www.w3.org/2000/01/rdf-schema#label> "Palo Alto (Miss.)".
      TTL
    end

    let(:model) do
      {
        general_info: {
          place: 'us'
        }
      }
    end

    include_examples 'mapper', described_class
  end

  describe 'general info date entered' do
    let(:ttl) do
      <<~TTL
        <#{admin_metadata_term}> <http://id.loc.gov/ontologies/bibframe/creationDate> "2020-10-12"@eng .
      TTL
    end

    let(:model) do
      {
        general_info: {
          date_entered: Date.new(2020, 10, 12)
        }
      }
    end

    include_examples 'mapper', described_class
  end

  describe 'general info date1' do
    let(:ttl) do
      <<~TTL
                  <#{instance_term}> <http://id.loc.gov/ontologies/bibframe/provisionActivity> _:b10.
        _:b10 a <http://id.loc.gov/ontologies/bibframe/Publication>;
            <http://id.loc.gov/ontologies/bibframe/date> "2020-10-12"@eng.
      TTL
    end

    let(:model) do
      {
        general_info: {
          date1: '2020-10-12'
        }
      }
    end

    include_examples 'mapper', described_class
  end

  describe 'general info language' do
    let(:ttl) do
      <<~TTL
                  <#{work_term}> <http://id.loc.gov/ontologies/bibframe/language> <http://id.loc.gov/vocabulary/languages/ace>.
        <http://id.loc.gov/vocabulary/languages/ace> <http://www.w3.org/2000/01/rdf-schema#label> "Achinese".
        <> <http://id.loc.gov/ontologies/bibframe/language> <http://id.loc.gov/vocabulary/languages/bug>.
        <http://id.loc.gov/vocabulary/languages/bug> <http://www.w3.org/2000/01/rdf-schema#label> "Bugis".
      TTL
    end

    let(:model) do
      {
        general_info: {
          language: 'ace'
        }
      }
    end

    include_examples 'mapper', described_class
  end
end
