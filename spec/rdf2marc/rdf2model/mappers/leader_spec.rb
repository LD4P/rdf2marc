# frozen_string_literal: true

require 'rdf2marc/rdf2model/mappers/mappers_shared_examples'

RSpec.describe Rdf2marc::Rdf2model::Mappers::Leader do
  context 'when mapping minimal graph' do
    let(:ttl) { '' }

    let(:model) do
      {
        bibliographic_level: 'monographic_component',
        type: 'language_material'
      }
    end

    include_examples 'mapper', described_class
  end

  describe 'record status' do
    context 'when a literal' do
      let(:ttl) do
        <<~TTL
          <#{admin_metadata_term}> <http://id.loc.gov/ontologies/bibframe/status> _:b17.
          _:b17 a <http://id.loc.gov/ontologies/bibframe/Status>;
            <http://id.loc.gov/ontologies/bibframe/code> "a"@eng.
        TTL
      end

      let(:model) do
        {
          bibliographic_level: 'monographic_component',
          type: 'language_material'
          # NOTE: It is not mapped; it is defaulted in the Leader struct
          # record_status: 'a'
        }
      end

      include_examples 'mapper', described_class
    end

    context 'when an mstatus URI' do
      let(:ttl) do
        <<~TTL
          <#{admin_metadata_term}> <http://id.loc.gov/ontologies/bibframe/status> _:b17.
          _:b17 a <http://id.loc.gov/ontologies/bibframe/Status>;
            <http://id.loc.gov/ontologies/bibframe/code> <http://id.loc.gov/vocabulary/mstatus/cancinv>.
        TTL
      end

      let(:model) do
        {
          bibliographic_level: 'monographic_component',
          type: 'language_material'
          # NOTE: It is not mapped; it is defaulted in the Leader struct
          # record_status: 'n'
        }
      end

      include_examples 'mapper', described_class
    end
  end

  describe 'type' do
    context 'when no subclasses' do
      let(:ttl) do
        <<~TTL
          <#{work_term}> a <http://id.loc.gov/ontologies/bibframe/Work>.
        TTL
      end

      let(:model) do
        {
          bibliographic_level: 'monographic_component',
          type: 'language_material'
        }
      end

      include_examples 'mapper', described_class
    end

    context 'when single subclass required for match' do
      let(:ttl) do
        <<~TTL
          <#{work_term}> a <http://id.loc.gov/ontologies/bibframe/Work>, <http://id.loc.gov/ontologies/bibframe/NotatedMusic>.
        TTL
      end

      let(:model) do
        {
          bibliographic_level: 'monographic_component',
          type: 'notated_music'
        }
      end

      include_examples 'mapper', described_class
    end

    context 'when multiple subclasses required for match' do
      let(:ttl) do
        <<~TTL
          <#{work_term}> a <http://id.loc.gov/ontologies/bibframe/Work>, <http://id.loc.gov/ontologies/bibframe/Manuscript>, <http://id.loc.gov/ontologies/bibframe/NotatedMusic>.
        TTL
      end

      let(:model) do
        {
          bibliographic_level: 'monographic_component',
          type: 'manuscript_notated_music'
        }
      end

      include_examples 'mapper', described_class
    end
  end

  describe 'bibliographic level' do
    context 'when no subclasses' do
      let(:ttl) do
        <<~TTL
          <#{work_term}> a <http://id.loc.gov/ontologies/bibframe/Work>, <http://id.loc.gov/ontologies/bibframe/Collection>.
        TTL
      end

      let(:model) do
        {
          bibliographic_level: 'collection',
          type: 'language_material'
        }
      end

      include_examples 'mapper', described_class
    end

    context 'when matching subclass' do
      let(:ttl) do
        <<~TTL
          <#{work_term}> a <http://id.loc.gov/ontologies/bibframe/Work>.
        TTL
      end

      let(:model) do
        {
          bibliographic_level: 'monographic_component',
          type: 'language_material'
        }
      end

      include_examples 'mapper', described_class
    end
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
        bibliographic_level: 'monographic_component',
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
        bibliographic_level: 'monographic_component',
        type: 'language_material',
        cataloging_form: 'aacr2'
      }
    end

    include_examples 'mapper', described_class
  end
end
