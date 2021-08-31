# frozen_string_literal: true

require 'rdf2marc/rdf2model/mappers/mappers_shared_examples'

RSpec.describe Rdf2marc::Rdf2model::Mappers::PhysicalDescriptionFields do
  context 'with minimal graph' do
    let(:ttl) { '' }

    let(:model) do
      {
        physical_descriptions: [{}]
      }
    end

    include_examples 'mapper', described_class
  end

  describe 'physical descriptions' do
    let(:ttl) do
      <<~TTL
                                  <#{instance_term}> <http://id.loc.gov/ontologies/bibframe/extent> _:b38.
        _:b38 a <http://id.loc.gov/ontologies/bibframe/Extent>;
            <http://www.w3.org/2000/01/rdf-schema#label> "149 pages"@eng, "1 score (16 p.)"@eng;
            <http://id.loc.gov/ontologies/bibframe/note> _:b39.
        _:b39 a <http://id.loc.gov/ontologies/bibframe/Note>;
            <http://www.w3.org/2000/01/rdf-schema#label> "dupe neg nitrate (copy 2)"@eng.
        <#{instance_term}> <http://id.loc.gov/ontologies/bibframe/extent> _:b40.
        _:b40 a <http://id.loc.gov/ontologies/bibframe/Extent>;
            <http://www.w3.org/2000/01/rdf-schema#label> "1 sound disc (20 min.)"@eng.
        <#{instance_term}> <http://id.loc.gov/ontologies/bibframe/dimensions> "10 x 27 cm"@eng, "7 1/4 x 3 1/2 in., 1/4 in. tape"@eng.
      TTL
    end

    let(:model) do
      {
        physical_descriptions: [
          {
            extents: ['1 score (16 p.)', '149 pages'],
            materials_specified: 'dupe neg nitrate (copy 2)'
          },
          {
            extents: ['1 sound disc (20 min.)']
          },
          {
            dimensions: ['10 x 27 cm', '7 1/4 x 3 1/2 in., 1/4 in. tape']
          }
        ]
      }
    end

    include_examples 'mapper', described_class
  end

  describe 'media types' do
    let(:ttl) do
      <<~TTL
                                  <#{instance_term}> <http://id.loc.gov/ontologies/bibframe/media> <http://id.loc.gov/vocabulary/mediaTypes/n>.
        <http://id.loc.gov/vocabulary/mediaTypes/n> <http://www.w3.org/2000/01/rdf-schema#label> "unmediated".
        <#{instance_term}> <http://id.loc.gov/ontologies/bibframe/media> <http://id.loc.gov/vocabulary/mediaTypes/h>.
        <http://id.loc.gov/vocabulary/mediaTypes/h> <http://www.w3.org/2000/01/rdf-schema#label> "microform".
      TTL
    end

    let(:model) do
      {
        physical_descriptions: [{}],
        media_types: [
          {
            authority_control_number_uri: 'http://id.loc.gov/vocabulary/mediaTypes/h',
            media_type_codes: ['h'],
            media_type_terms: ['microform']
          },
          {
            authority_control_number_uri: 'http://id.loc.gov/vocabulary/mediaTypes/n',
            media_type_codes: ['n'],
            media_type_terms: ['unmediated']
          }
        ]
      }
    end

    include_examples 'mapper', described_class
  end

  describe 'carrier types' do
    let(:ttl) do
      <<~TTL
                                  <#{instance_term}> <http://id.loc.gov/ontologies/bibframe/carrier> <http://id.loc.gov/vocabulary/carriers/nc>.
        <http://id.loc.gov/vocabulary/carriers/nc> <http://www.w3.org/2000/01/rdf-schema#label> "volume".
        <#{instance_term}> <http://id.loc.gov/ontologies/bibframe/carrier> <http://id.loc.gov/vocabulary/carriers/sg>.
        <http://id.loc.gov/vocabulary/carriers/sg> <http://www.w3.org/2000/01/rdf-schema#label> "audio cartridge".
      TTL
    end

    let(:model) do
      {
        physical_descriptions: [{}],
        carrier_types: [
          {
            authority_control_number_uri: 'http://id.loc.gov/vocabulary/carriers/nc',
            carrier_type_codes: ['nc'],
            carrier_type_terms: ['volume']
          },
          {
            authority_control_number_uri: 'http://id.loc.gov/vocabulary/carriers/sg',
            carrier_type_codes: ['sg'],
            carrier_type_terms: ['audio cartridge']
          }
        ]
      }
    end

    include_examples 'mapper', described_class
  end

  describe 'content types' do
    let(:ttl) do
      <<~TTL
                                  <#{work_term}> <http://id.loc.gov/ontologies/bibframe/content> <http://id.loc.gov/vocabulary/contentTypes/txt>.
        <http://id.loc.gov/vocabulary/contentTypes/txt> <http://www.w3.org/2000/01/rdf-schema#label> "text".
        <#{work_term}> <http://id.loc.gov/ontologies/bibframe/content> <http://id.loc.gov/vocabulary/contentTypes/sti>.
        <http://id.loc.gov/vocabulary/contentTypes/sti> <http://www.w3.org/2000/01/rdf-schema#label> "still image".
      TTL
    end

    let(:model) do
      {
        physical_descriptions: [{}],
        content_types: [
          {
            authority_control_number_uri: 'http://id.loc.gov/vocabulary/contentTypes/sti',
            content_type_codes: ['sti'],
            content_type_terms: ['still image']
          },
          {
            authority_control_number_uri: 'http://id.loc.gov/vocabulary/contentTypes/txt',
            content_type_codes: ['txt'],
            content_type_terms: ['text']
          }
        ]
      }
    end

    include_examples 'mapper', described_class
  end
end
