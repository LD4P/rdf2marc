# frozen_string_literal: true

require 'rdf2marc/rdf2model/mappers/mappers_shared_examples'

RSpec.describe Rdf2marc::Rdf2model::Mappers::AddedEntryFields, :vcr do
  context 'with minimal graph' do
    let(:ttl) { '' }

    let(:model) { {} }

    include_examples 'mapper', described_class
  end

  describe 'added personal names' do
    context 'mapping from multiple BF.Person and BF.Family URIs' do
      let(:ttl) do
        <<~TTL
          <#{work_term}> <http://id.loc.gov/ontologies/bibframe/contribution> _:b1.
          _:b1 a <http://id.loc.gov/ontologies/bibframe/Contribution>;
              <http://id.loc.gov/ontologies/bibframe/agent> _:b2.
          _:b2 a <http://id.loc.gov/ontologies/bibframe/Person>;
              <http://www.w3.org/1999/02/22-rdf-syntax-ns#value> <http://id.loc.gov/authorities/names/no2005086644>.
          <http://id.loc.gov/authorities/names/no2005086644> <http://www.w3.org/2000/01/rdf-schema#label> "Jung, Carl".
          _:b1 <http://id.loc.gov/ontologies/bibframe/agent> _:b3.
          _:b3 a <http://id.loc.gov/ontologies/bibframe/Family>;
              <http://www.w3.org/1999/02/22-rdf-syntax-ns#value> <http://id.loc.gov/authorities/names/no2020066646>.
          <http://id.loc.gov/authorities/names/no2020066646> <http://www.w3.org/2000/01/rdf-schema#label> "http://id.loc.gov/authorities/names/no2020066646".
        TTL
      end

      let(:model) do
        {
          personal_names: [
            {
              type: 'surname',
              thesaurus: 'lcsh',
              personal_name: 'Jung, Carl',
              authority_record_control_numbers: ['http://id.loc.gov/authorities/names/no2005086644']
            },
            {
              thesaurus: 'lcsh',
              authority_record_control_numbers: ['http://id.loc.gov/authorities/names/no2020066646'],
              personal_name: 'Kennedy (Family', title_and_words: ['Covington, Ky.)'], type: 'family_name'
            }
          ]
        }
      end

      include_examples 'mapper', described_class
    end
    context 'mapping from multiple BF.Person and BF.Family literals' do
      let(:ttl) do
        <<~TTL
          <#{work_term}> <http://id.loc.gov/ontologies/bibframe/contribution> _:b7.
          _:b7 a <http://id.loc.gov/ontologies/bibframe/Contribution>;
              <http://id.loc.gov/ontologies/bibframe/agent> _:b8.
          _:b8 a <http://id.loc.gov/ontologies/bibframe/Person>;
              <http://www.w3.org/1999/02/22-rdf-syntax-ns#value> "Jung, Carl", "Kennedy Family".
        TTL
      end

      let(:model) do
        { personal_names: [
          {
            thesaurus: 'not_specified',
            personal_name: 'Jung, Carl'
          },
          {
            thesaurus: 'not_specified',
            personal_name: 'Kennedy Family'
          }
        ] }
      end

      include_examples 'mapper', described_class
    end
  end

  describe 'added corporate names' do
    context 'mapping from multiple BF.Organzation URIs' do
      let(:ttl) do
        <<~TTL
          <#{work_term}> <http://id.loc.gov/ontologies/bibframe/contribution> _:b4.
          _:b4 a <http://id.loc.gov/ontologies/bibframe/Contribution>;
              <http://id.loc.gov/ontologies/bibframe/agent> _:b5.
          _:b5 a <http://id.loc.gov/ontologies/bibframe/Organization>;
              <http://www.w3.org/1999/02/22-rdf-syntax-ns#value> <http://id.loc.gov/authorities/names/nb2007013471>.
          <http://id.loc.gov/authorities/names/nb2007013471> <http://www.w3.org/2000/01/rdf-schema#label> "Iranian Chemical Society".
          _:b5 <http://www.w3.org/1999/02/22-rdf-syntax-ns#value> <http://id.loc.gov/authorities/names/n79122611>.
          <http://id.loc.gov/authorities/names/n79122611> <http://www.w3.org/2000/01/rdf-schema#label> "United States. Army Map Service".
        TTL
      end

      let(:model) do
        {
          corporate_names: [
            {
              type: 'jurisdiction',
              thesaurus: 'lcsh',
              corporate_name: 'United States.',
              subordinate_units: ['Army Map Service'],
              authority_record_control_numbers: ['http://id.loc.gov/authorities/names/n79122611']
            },
            {
              type: 'direct',
              thesaurus: 'lcsh',
              corporate_name: 'Iranian Chemical Society',
              authority_record_control_numbers: ['http://id.loc.gov/authorities/names/nb2007013471']
            }
          ]
        }
      end

      include_examples 'mapper', described_class
    end

    context 'mapping from multiple BF.Organzation literals' do
      let(:ttl) do
        <<~TTL
          <#{work_term}> <http://id.loc.gov/ontologies/bibframe/contribution> _:b9.
           _:b9 a <http://id.loc.gov/ontologies/bibframe/Contribution>;
               <http://id.loc.gov/ontologies/bibframe/agent> _:b10.
           _:b10 a <http://id.loc.gov/ontologies/bibframe/Organization>;
               <http://www.w3.org/1999/02/22-rdf-syntax-ns#value> "Iranian Chemical Society", "United States. Army Map Service".
        TTL
      end

      let(:model) do
        {
          corporate_names: [
            {
              thesaurus: 'not_specified',
              corporate_name: 'Iranian Chemical Society'
            },
            {
              thesaurus: 'not_specified',
              corporate_name: 'United States. Army Map Service'
            }
          ]
        }
      end

      include_examples 'mapper', described_class
    end
  end

  describe 'added meeting names' do
    context 'mapping from multiple BF.Meeting URIs' do
      let(:ttl) do
        <<~TTL
           <#{work_term}> <http://id.loc.gov/ontologies/bibframe/contribution> _:b11.
          _:b11 a <http://id.loc.gov/ontologies/bibframe/Contribution>;
              <http://id.loc.gov/ontologies/bibframe/agent> _:b12.
          _:b12 a <http://id.loc.gov/ontologies/bibframe/Meeting>;
              <http://www.w3.org/1999/02/22-rdf-syntax-ns#value> <http://id.loc.gov/authorities/names/n81133545>.
          <http://id.loc.gov/authorities/names/n81133545> <http://www.w3.org/2000/01/rdf-schema#label> "Van Cliburn International Piano Competition".
          _:b12 <http://www.w3.org/1999/02/22-rdf-syntax-ns#value> <http://id.loc.gov/authorities/names/n81027412>.
          <http://id.loc.gov/authorities/names/n81027412> <http://www.w3.org/2000/01/rdf-schema#label> "Women and National Health Insurance Meeting (1980 : Washington, D.C.)".
        TTL
      end

      let(:model) do
        {
          meeting_names: [
            {
              type: 'direct',
              thesaurus: 'lcsh',
              meeting_name: 'Women and National Health Insurance Meeting',
              meeting_locations: ['Washington, D.C.'],
              meeting_dates: ['1980'],
              authority_record_control_numbers: ['http://id.loc.gov/authorities/names/n81027412']
            },
            {
              type: 'direct',
              thesaurus: 'lcsh',
              meeting_name: 'Van Cliburn International Piano Competition',
              authority_record_control_numbers: ['http://id.loc.gov/authorities/names/n81133545']
            }
          ]
        }
      end

      include_examples 'mapper', described_class
    end

    context 'mapping from multiple BF.Meeting literals' do
      let(:ttl) do
        <<~TTL
          <#{work_term}> <http://id.loc.gov/ontologies/bibframe/contribution> _:b13.
          _:b13 a <http://id.loc.gov/ontologies/bibframe/Contribution>;
              <http://id.loc.gov/ontologies/bibframe/agent> _:b14.
          _:b14 a <http://id.loc.gov/ontologies/bibframe/Meeting>;
              <http://www.w3.org/1999/02/22-rdf-syntax-ns#value> "Women and National Health Insurance Meeting", "Van Cliburn International Piano Competition".
          
        TTL
      end

      let(:model) do
        {
          meeting_names: [
            {
              thesaurus: 'not_specified',
              meeting_name: 'Van Cliburn International Piano Competition'
            },
            {
              thesaurus: 'not_specified',
              meeting_name: 'Women and National Health Insurance Meeting'
            }
          ]
        }
      end

      include_examples 'mapper', described_class
    end
  end
end
