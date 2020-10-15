# frozen_string_literal: true

require 'rdf2marc/rdf2model/mappers/mappers_shared_examples'

RSpec.describe Rdf2marc::Rdf2model::Mappers::SubjectAccessFields, :vcr do
  context 'with minimal graph' do
    let(:ttl) { '' }

    let(:model) { {} }

    include_examples 'mapper', described_class
  end

  context 'mapping from literal' do
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
            corporate_name: 'Ford Motor Company.',
            subordinate_units: ['Ford Division'],
            authority_record_control_numbers: ['http://id.loc.gov/authorities/names/n78088613']
          },
          {
            type: 'direct',
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
            personal_name: 'Mellon, Andrew',
            authority_record_control_numbers: ['http://id.loc.gov/authorities/names/nb2010025455']
          },
          {
            type: 'family_name',
            personal_name: 'Mellon family',
            authority_record_control_numbers: ['http://id.loc.gov/authorities/subjects/sh94002335']
          }
        ]
      }
    end

    include_examples 'mapper', described_class
  end

  describe 'geographic names' do
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
            geographic_name: 'Menlo Park (Calif.)',
            authority_record_control_numbers: ['http://id.loc.gov/authorities/names/n81024722']
          },
          {
            geographic_name: 'East Palo Alto (Calif.)',
            authority_record_control_numbers: ['http://id.loc.gov/authorities/names/n85186120']
          }
        ]
      }
    end

    include_examples 'mapper', described_class
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
            meeting_name: 'Auchenorrhyncha Meeting',
            authority_record_control_numbers: ['http://id.loc.gov/authorities/names/n2013185327']
          },
          {
            type: 'direct',
            meeting_name: 'Bacteriophage Meeting',
            authority_record_control_numbers: ['http://id.loc.gov/authorities/names/n81025771']
          }
        ]
      }
    end

    include_examples 'mapper', described_class
  end

  describe 'topical terms' do
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
            topical_term_or_geo_name: 'Historiography',
            authority_record_control_numbers: ['http://id.loc.gov/authorities/subjects/sh85061211']
          },
          {
            topical_term_or_geo_name: 'Naval history',
            authority_record_control_numbers: ['http://id.loc.gov/authorities/subjects/sh85090384']
          }
        ]
      }
    end

    include_examples 'mapper', described_class
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
    context 'mapping from multiple URIs' do
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
              genre_form_data: 'Diaries',
              term_source: 'lcgft',
              authority_record_control_numbers: ['http://id.loc.gov/authorities/genreForms/gf2014026085']
            },
            {
              genre_form_data: 'Rosaries (Prayer books)',
              term_source: 'lcgft',
              authority_record_control_numbers: ['http://id.loc.gov/authorities/genreForms/gf2015026083']
            }
          ]
        }
      end

      include_examples 'mapper', described_class
    end

    context 'mapping from multiple literals' do
      let(:ttl) do
        <<~TTL
          <#{work_term}> <http://id.loc.gov/ontologies/bibframe/genreForm> "Diaries", "Rosaries (Prayer books)".
        TTL
      end

      let(:model) do
        {
          genre_forms: [
            {
              genre_form_data: 'Diaries'
            },
            {
              genre_form_data: 'Rosaries (Prayer books)'
            }
          ]
        }
      end

      include_examples 'mapper', described_class
    end
  end
end
