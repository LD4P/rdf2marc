# frozen_string_literal: true

require 'rdf2marc/rdf2model/mappers/mappers_shared_examples'

RSpec.describe Rdf2marc::Rdf2model::Mappers::SubjectAccessFields, :vcr do
  context 'with minimal graph' do
    let(:ttl) { '' }

    let(:model) { {} }

    include_examples 'mapper', described_class
  end

  context 'when mapping from literal' do
    let(:ttl) do
      <<~TTL
        <#{work_term}> <http://id.loc.gov/ontologies/bibframe/subject> "Weber, Max".
      TTL
    end

    # Ignores the literal.
    let(:model) { {} }

    include_examples 'mapper', described_class
  end

  describe 'corporate names' do
    let(:ttl) do
      <<~TTL
                    <#{work_term}> <http://id.loc.gov/ontologies/bibframe/subject> <http://id.loc.gov/authorities/names/n78088613> .
        <http://id.loc.gov/authorities/names/n78088613> <http://www.w3.org/2000/01/rdf-schema#label> "Ford Motor Company. Ford Division" .
        <#{work_term}> <http://id.loc.gov/ontologies/bibframe/subject> <http://id.loc.gov/authorities/names/n81109238> .
        <http://id.loc.gov/entities/providers/1dcaf3cdbf908ecc631d6b4524abe1cf> <http://www.w3.org/2000/01/rdf-schema#label> "American Honda Motor Company" .
      TTL
    end

    let(:model) do
      {
        corporate_names: [
          {
            type: 'direct',
            thesaurus: 'lcsh',
            corporate_name: 'Ford Motor Company.',
            subordinate_units: ['Ford Division'],
            authority_record_control_numbers: ['http://id.loc.gov/authorities/names/n78088613']
          },
          {
            type: 'direct',
            thesaurus: 'lcsh',
            corporate_name: 'American Honda Motor Company',
            authority_record_control_numbers: ['http://id.loc.gov/authorities/names/n81109238']
          }
        ]
      }
    end

    include_examples 'mapper', described_class
  end

  describe 'personal and family names' do
    let(:ttl) do
      <<~TTL
                    <#{work_term}> <http://id.loc.gov/ontologies/bibframe/subject> <http://id.loc.gov/authorities/subjects/sh94002335>.
        <http://id.loc.gov/authorities/subjects/sh94002335> <http://www.w3.org/2000/01/rdf-schema#label> "Mellon family".
        <#{work_term}> <http://id.loc.gov/ontologies/bibframe/subject> <http://id.loc.gov/authorities/names/nb2010025455>.
        <http://id.loc.gov/authorities/names/nb2010025455> <http://www.w3.org/2000/01/rdf-schema#label> "Mellon, Andrew".
      TTL
    end

    let(:model) do
      {
        personal_names: [
          {
            type: 'surname',
            thesaurus: 'lcsh',
            personal_name: 'Mellon, Andrew',
            authority_record_control_numbers: ['http://id.loc.gov/authorities/names/nb2010025455']
          },
          {
            type: 'family_name',
            thesaurus: 'lcsh',
            personal_name: 'Mellon family',
            authority_record_control_numbers: ['http://id.loc.gov/authorities/subjects/sh94002335']
          }
        ]
      }
    end

    include_examples 'mapper', described_class
  end

  describe 'geographic names' do
    context 'when loading from LOC' do
      let(:ttl) do
        <<~TTL
                      <#{work_term}> <http://id.loc.gov/ontologies/bibframe/subject> <http://id.loc.gov/authorities/names/n85186120>.
          <http://id.loc.gov/authorities/names/n85186120> <http://www.w3.org/2000/01/rdf-schema#label> "East Palo Alto (Calif.)".
          <#{work_term}> <http://id.loc.gov/ontologies/bibframe/subject> <http://id.loc.gov/authorities/names/n81024722>.
          <http://id.loc.gov/authorities/names/n81024722> <http://www.w3.org/2000/01/rdf-schema#label> "Menlo Park (Calif.)".
        TTL
      end

      let(:model) do
        {
          geographic_names: [
            {
              thesaurus: 'lcsh',
              geographic_name: 'Menlo Park (Calif.)',
              authority_record_control_numbers: ['http://id.loc.gov/authorities/names/n81024722']
            },
            {
              thesaurus: 'lcsh',
              geographic_name: 'East Palo Alto (Calif.)',
              authority_record_control_numbers: ['http://id.loc.gov/authorities/names/n85186120']
            }
          ]
        }
      end

      include_examples 'mapper', described_class
    end

    context 'when loading from FAST' do
      let(:ttl) do
        <<~TTL
                      <#{work_term}> <http://id.loc.gov/ontologies/bibframe/subject> <http://id.worldcat.org/fast/1210272>.
          <http://id.worldcat.org/fast/1210272> <http://www.w3.org/2000/01/rdf-schema#label> "Ger.".
        TTL
      end

      let(:model) do
        {
          geographic_names: [
            {
              thesaurus: 'subfield2',
              source: 'fast',
              geographic_name: 'Germany',
              authority_record_control_numbers: ['http://id.worldcat.org/fast/1210272']
            }
          ]
        }
      end

      include_examples 'mapper', described_class
    end
  end

  describe 'event names' do
    context 'when loading from FAST' do
      let(:ttl) do
        <<~TTL
                      <#{work_term}> <http://id.loc.gov/ontologies/bibframe/subject> <http://id.worldcat.org/fast/1181267>.
          <http://id.worldcat.org/fast/1181267> <http://www.w3.org/2000/01/rdf-schema#label> "Ger.".
        TTL
      end

      let(:model) do
        {
          event_names: [
            {
              thesaurus: 'subfield2',
              source: 'fast',
              name: 'World War (1939-1945)--Sounds',
              uris: ['http://id.worldcat.org/fast/1181267']
            }
          ]
        }
      end

      include_examples 'mapper', described_class
    end
  end

  describe 'meeting names' do
    let(:ttl) do
      <<~TTL
                    <#{work_term}> <http://id.loc.gov/ontologies/bibframe/subject> <http://id.loc.gov/authorities/names/n81025771>.
        <http://id.loc.gov/authorities/names/n81025771> <http://www.w3.org/2000/01/rdf-schema#label> "Bacteriophage Meeting".
        <#{work_term}> <http://id.loc.gov/ontologies/bibframe/subject> <http://id.loc.gov/authorities/names/n2013185327>.
        <http://id.loc.gov/authorities/names/n2013185327> <http://www.w3.org/2000/01/rdf-schema#label> "Auchenorrhyncha Meeting".
      TTL
    end

    let(:model) do
      {
        meeting_names: [
          {
            type: 'direct',
            thesaurus: 'lcsh',
            meeting_name: 'Auchenorrhyncha Meeting',
            authority_record_control_numbers: ['http://id.loc.gov/authorities/names/n2013185327']
          },
          {
            type: 'direct',
            thesaurus: 'lcsh',
            meeting_name: 'Bacteriophage Meeting',
            authority_record_control_numbers: ['http://id.loc.gov/authorities/names/n81025771']
          }
        ]
      }
    end

    include_examples 'mapper', described_class
  end

  describe 'topical terms' do
    context 'when loading from LOC' do
      let(:ttl) do
        <<~TTL
                      <#{work_term}> <http://id.loc.gov/ontologies/bibframe/subject> <http://id.loc.gov/authorities/subjects/sh85061211>.
          <http://id.loc.gov/authorities/subjects/sh85061211> <http://www.w3.org/2000/01/rdf-schema#label> "Historiography".
          <#{work_term}> <http://id.loc.gov/ontologies/bibframe/subject> <http://id.loc.gov/authorities/subjects/sh85090384>.
          <http://id.loc.gov/authorities/subjects/sh85090384> <http://www.w3.org/2000/01/rdf-schema#label> "Naval history".
        TTL
      end

      let(:model) do
        {
          topical_terms: [
            {
              thesaurus: 'lcsh',
              topical_term_or_geo_name: 'Historiography',
              authority_record_control_numbers: ['http://id.loc.gov/authorities/subjects/sh85061211']
            },
            {
              thesaurus: 'lcsh',
              topical_term_or_geo_name: 'Naval history',
              authority_record_control_numbers: ['http://id.loc.gov/authorities/subjects/sh85090384']
            }
          ]
        }
      end

      include_examples 'mapper', described_class
    end

    context 'when loading from FAST' do
      let(:ttl) do
        <<~TTL
                      <#{work_term}> <http://id.loc.gov/ontologies/bibframe/subject> <http://id.worldcat.org/fast/1015277>.
          <http://id.worldcat.org/fast/1015277> <http://www.w3.org/2000/01/rdf-schema#label> "med.".
        TTL
      end

      let(:model) do
        {
          topical_terms: [
            {
              thesaurus: 'subfield2',
              heading_source: 'fast',
              topical_term_or_geo_name: 'Medicine, Medieval',
              authority_record_control_numbers: ['http://id.worldcat.org/fast/1015277']
            }
          ]
        }
      end

      include_examples 'mapper', described_class
    end
  end

  describe 'complex subjects' do
    let(:ttl) do
      <<~TTL
                    <#{work_term}> <http://id.loc.gov/ontologies/bibframe/subject> <http://id.loc.gov/authorities/subjects/sh2009113554>.
        <http://id.loc.gov/authorities/subjects/sh2009113554> <http://www.w3.org/2000/01/rdf-schema#label> "Actresses--Drama".
      TTL
    end

    let(:model) do
      {
        topical_terms: [
          {
            thesaurus: 'lcsh',
            authority_record_control_numbers: ['http://id.loc.gov/authorities/subjects/sh2009113554'],
            form_subdivisions: ['Drama'],
            topical_term_or_geo_name: 'Actresses'
          }
        ]
      }
    end

    include_examples 'mapper', described_class
  end

  describe 'genre forms' do
    context 'when mapping from multiple URIs' do
      let(:ttl) do
        <<~TTL
                      <#{work_term}> <http://id.loc.gov/ontologies/bibframe/genreForm> <http://id.loc.gov/authorities/genreForms/gf2014026085>.
          <http://id.loc.gov/authorities/genreForms/gf2014026085> <http://www.w3.org/2000/01/rdf-schema#label> "Diaries".
          <#{work_term}> <http://id.loc.gov/ontologies/bibframe/genreForm> <http://id.loc.gov/authorities/genreForms/gf2015026083>.
          <http://id.loc.gov/authorities/genreForms/gf2015026083> <http://www.w3.org/2000/01/rdf-schema#label> "Rosaries (Prayer books)".
        TTL
      end

      let(:model) do
        {
          genre_forms: [
            {
              thesaurus: 'subfield2',
              genre_form_data: 'Diaries',
              term_source: 'lcgft',
              authority_record_control_numbers: ['http://id.loc.gov/authorities/genreForms/gf2014026085']
            },
            {
              thesaurus: 'subfield2',
              genre_form_data: 'Rosaries (Prayer books)',
              term_source: 'lcgft',
              authority_record_control_numbers: ['http://id.loc.gov/authorities/genreForms/gf2015026083']
            }
          ]
        }
      end

      include_examples 'mapper', described_class
    end

    context 'when mapping from multiple literals' do
      let(:ttl) do
        <<~TTL
          <#{work_term}> <http://id.loc.gov/ontologies/bibframe/genreForm> "Diaries", "Rosaries (Prayer books)".
        TTL
      end

      let(:model) do
        {
          genre_forms: [
            {
              thesaurus: 'not_specified',
              genre_form_data: 'Diaries'
            },
            {
              thesaurus: 'not_specified',
              genre_form_data: 'Rosaries (Prayer books)'
            }
          ]
        }
      end

      include_examples 'mapper', described_class
    end
  end
end
