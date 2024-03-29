# frozen_string_literal: true

require 'rdf2marc/rdf2model/mappers/mappers_shared_examples'

RSpec.describe Rdf2marc::Rdf2model::Mappers::HoldingsEtcFields do
  let(:today) { Date.new(2020, 10, 13) }

  before do
    allow(Date).to receive(:today).and_return(today)
  end

  context 'with minimal graph' do
    let(:ttl) { '' }

    let(:model) do
      {
        description_conversion_infos: [
          {
            conversion_date: today,
            conversion_process: 'Sinopia rdf2marc',
            source_metadata_identifier: 'https://api.sinopia.io/resource/test_instance',
            uri: 'https://github.com/LD4P/rdf2marc'
          }
        ]
      }
    end

    include_examples 'mapper', described_class
  end

  describe 'electronic locations' do
    let(:ttl) do
      <<~TTL
        <#{instance_term}> <http://id.loc.gov/ontologies/bibframe/electronicLocator> <https://library.stanford.edu/>, <https://library.stanford.edu/department/digital-library-systems-and-services-dlss>.
      TTL
    end

    let(:model) do
      {
        description_conversion_infos: [
          {
            conversion_date: today,
            conversion_process: 'Sinopia rdf2marc',
            source_metadata_identifier: 'https://api.sinopia.io/resource/test_instance',
            uri: 'https://github.com/LD4P/rdf2marc'
          }
        ],
        electronic_locations: [
          {
            uris: ['https://library.stanford.edu/']
          },
          {
            uris: ['https://library.stanford.edu/department/digital-library-systems-and-services-dlss']
          }
        ]
      }
    end

    include_examples 'mapper', described_class
  end
end
