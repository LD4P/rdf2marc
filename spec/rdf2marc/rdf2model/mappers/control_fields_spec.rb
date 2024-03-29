# frozen_string_literal: true

require 'rdf2marc/rdf2model/mappers/mappers_shared_examples'

RSpec.describe Rdf2marc::Rdf2model::Mappers::ControlFields, :vcr do
  context 'when mapping minimal graph' do
    let(:ttl) { '' }

    let(:model) do
      {
        general_info: {
          place: 'xx'
        }
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
        general_info: {
          place: 'xx'
        },
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
            <http://id.loc.gov/ontologies/bibframe/place> <http://id.loc.gov/vocabulary/countries/ae>.
        <http://id.loc.gov/vocabulary/countries/ae> <http://www.w3.org/2000/01/rdf-schema#label> "Algeria".
      TTL
    end

    let(:model) do
      {
        general_info: {
          place: 'ae'
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
          date_entered: Date.new(2020, 10, 12),
          place: 'xx'
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
          date1: '2020-10-12',
          place: 'xx'
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
          language: 'ace',
          place: 'xx'
        }
      }
    end

    include_examples 'mapper', described_class
  end

  describe 'general info book illustrative content' do
    let(:ttl) do
      <<~TTL
        <#{work_term}> <http://id.loc.gov/ontologies/bibframe/illustrativeContent> <http://id.loc.gov/vocabulary/millus/ill> .
      TTL
    end

    let(:model) do
      {
        general_info: {
          book_illustrative_content: 'Illustrations',
          place: 'xx'
        }
      }
    end

    include_examples 'mapper', described_class
  end
end
