# frozen_string_literal: true

require 'rdf2marc/rdf2model/mappers/mappers_shared_examples'

RSpec.describe Rdf2marc::Rdf2model::Mappers::NumberAndCodeFields, :vcr do
  context 'with minimal graph' do
    let(:ttl) { '' }

    let(:model) do
      {
        cataloging_source: {},
        geographic_area_code: {},
        lccn: {}
      }
    end

    include_examples 'mapper', described_class
  end

  describe 'lccn' do
    # Includes an extra LCCN and an LCCN without a value, which are ignored.
    let(:ttl) do
      <<~TTL
                                  <#{instance_term}> <http://id.loc.gov/ontologies/bibframe/identifiedBy> _:b2.
        _:b2 a <http://id.loc.gov/ontologies/bibframe/Lccn>;
            <http://www.w3.org/1999/02/22-rdf-syntax-ns#value> "85153773"@eng.
        <#{instance_term}> <http://id.loc.gov/ontologies/bibframe/identifiedBy> _:b3.
        _:b3 a <http://id.loc.gov/ontologies/bibframe/Lccn>;
            <http://www.w3.org/1999/02/22-rdf-syntax-ns#value> "nuc76039265"@eng;
            <http://id.loc.gov/ontologies/bibframe/status> <http://id.loc.gov/vocabulary/mstatus/cancinv>.
        <http://id.loc.gov/vocabulary/mstatus/cancinv> <http://www.w3.org/2000/01/rdf-schema#label> "canceled or invalid".
        <#{instance_term}> <http://id.loc.gov/ontologies/bibframe/identifiedBy> _:b4.
        _:b4 a <http://id.loc.gov/ontologies/bibframe/Lccn>;
            <http://www.w3.org/1999/02/22-rdf-syntax-ns#value> "2001627090"@eng;
            <http://id.loc.gov/ontologies/bibframe/status> <http://id.loc.gov/vocabulary/mstatus/cancinv>.
        <#{instance_term}> <http://id.loc.gov/ontologies/bibframe/identifiedBy> _:b5.
        _:b5 a <http://id.loc.gov/ontologies/bibframe/Lccn>;
            <http://www.w3.org/1999/02/22-rdf-syntax-ns#value> "2001336783"@eng.
        <#{instance_term}> <http://id.loc.gov/ontologies/bibframe/identifiedBy> _:b6.
        _:b6 a <http://id.loc.gov/ontologies/bibframe/Lccn>;
            <http://id.loc.gov/ontologies/bibframe/status> <http://id.loc.gov/vocabulary/mstatus/cancinv>.
      TTL
    end

    let(:model) do
      {
        cataloging_source: {},
        geographic_area_code: {},
        lccn: {
          cancelled_lccns: %w[nuc76039265 2001627090],
          lccn: '2001336783'
        }
      }
    end

    include_examples 'mapper', described_class
  end

  describe 'isbn' do
    # Includes an ISBN without a value which is ignored.
    let(:ttl) do
      <<~TTL
                                  <#{instance_term}> <http://id.loc.gov/ontologies/bibframe/identifiedBy> _:b7.
        _:b7 a <http://id.loc.gov/ontologies/bibframe/Isbn>;
            <http://www.w3.org/1999/02/22-rdf-syntax-ns#value> "0491001304"@eng;
            <http://id.loc.gov/ontologies/bibframe/qualifier> "paperback"@eng.
        <#{instance_term}> <http://id.loc.gov/ontologies/bibframe/identifiedBy> _:b8.
        _:b8 a <http://id.loc.gov/ontologies/bibframe/Isbn>;
            <http://www.w3.org/1999/02/22-rdf-syntax-ns#value> "0914378260"@eng;
            <http://id.loc.gov/ontologies/bibframe/status> <http://id.loc.gov/vocabulary/mstatus/cancinv>.
        <http://id.loc.gov/vocabulary/mstatus/cancinv> <http://www.w3.org/2000/01/rdf-schema#label> "canceled or invalid".
        <#{instance_term}> <http://id.loc.gov/ontologies/bibframe/identifiedBy> _:b9.
        _:b9 a <http://id.loc.gov/ontologies/bibframe/Isbn>;
            <http://www.w3.org/1999/02/22-rdf-syntax-ns#value> "0394502884"@eng;
            <http://id.loc.gov/ontologies/bibframe/status> <http://id.loc.gov/vocabulary/mstatus/cancinv>.
        <#{instance_term}> <http://id.loc.gov/ontologies/bibframe/identifiedBy> _:b10.
        _:b10 a <http://id.loc.gov/ontologies/bibframe/Isbn>;
            <http://www.w3.org/1999/02/22-rdf-syntax-ns#value> "0877790086"@eng.
        <#{instance_term}> <http://id.loc.gov/ontologies/bibframe/identifiedBy> _:b11.
        _:b11 a <http://id.loc.gov/ontologies/bibframe/Isbn>;
            <http://id.loc.gov/ontologies/bibframe/status> <http://id.loc.gov/vocabulary/mstatus/cancinv>.
      TTL
    end

    let(:model) do
      {
        lccn: {},
        isbns: [
          {
            isbn: '0877790086'
          },
          {
            isbn: '0491001304',
            qualifying_infos: ['paperback']
          },
          {
            cancelled_isbns: ['0914378260']
          },
          {
            cancelled_isbns: ['0394502884']
          }
        ],
        cataloging_source: {},
        geographic_area_code: {}
      }
    end

    include_examples 'mapper', described_class
  end

  describe 'legacy cataloging source agency' do
    let(:ttl) do
      <<~TTL
                                  <#{admin_metadata_term}> <http://id.loc.gov/ontologies/bibframe/source> <http://id.loc.gov/vocabulary/organizations/cst>.
        <http://id.loc.gov/vocabulary/organizations/cst> <http://www.w3.org/2000/01/rdf-schema#label> "http://id.loc.gov/vocabulary/organizations/cst".
        <#{admin_metadata_term}> <http://id.loc.gov/ontologies/bibframe/source> <http://id.loc.gov/vocabulary/organizations/vif>.
        <http://id.loc.gov/vocabulary/organizations/vif> <http://www.w3.org/2000/01/rdf-schema#label> "http://id.loc.gov/vocabulary/organizations/vif".
      TTL
    end

    let(:model) do
      {
        lccn: {},
        cataloging_source: {
          cataloging_agency: 'cst',
          transcribing_agency: 'cst'
        },
        geographic_area_code: {}
      }
    end

    include_examples 'mapper', described_class
  end

  describe 'cataloging source agency' do
    let(:ttl) do
      <<~TTL
        <#{admin_metadata_term}> <http://id.loc.gov/ontologies/bibframe/assigner> <http://id.loc.gov/vocabulary/organizations/cst>.
        <http://id.loc.gov/vocabulary/organizations/cst> a <http://id.loc.gov/ontologies/bibframe/Agent>;
        <http://www.w3.org/2000/01/rdf-schema#label> "Stanford University"@en.#{'                                  '}
      TTL
    end

    let(:model) do
      {
        lccn: {},
        cataloging_source: {
          cataloging_agency: 'cst',
          transcribing_agency: 'cst'
        },
        geographic_area_code: {}
      }
    end

    include_examples 'mapper', described_class
  end

  describe 'cataloging source modifying agency' do
    let(:ttl) do
      <<~TTL
                                  <#{admin_metadata_term}> <http://id.loc.gov/ontologies/bibframe/descriptionModifier> <http://id.loc.gov/vocabulary/organizations/ma>.
            <http://id.loc.gov/vocabulary/organizations/ma> <http://www.w3.org/2000/01/rdf-schema#label> "http://id.loc.gov/vocabulary/organizations/ma".
        <#{admin_metadata_term}> <http://id.loc.gov/ontologies/bibframe/descriptionModifier> <http://id.loc.gov/vocabulary/organizations/njrnl>.
            <http://id.loc.gov/vocabulary/organizations/njrnl> <http://www.w3.org/2000/01/rdf-schema#label> "http://id.loc.gov/vocabulary/organizations/njrnl".
      TTL
    end

    let(:model) do
      {
        lccn: {},
        cataloging_source: {
          modifying_agencies: %w[ma njrnl]
        },
        geographic_area_code: {}
      }
    end

    include_examples 'mapper', described_class
  end

  describe 'cataloging source description conventions' do
    let(:ttl) do
      <<~TTL
                                  <#{admin_metadata_term}> <http://id.loc.gov/ontologies/bibframe/descriptionConventions> <http://id.loc.gov/vocabulary/descriptionConventions/dcrmg>.
        <http://id.loc.gov/vocabulary/descriptionConventions/dcrmg> <http://www.w3.org/2000/01/rdf-schema#label> "DCRM(G): Descriptive cataloging of rare materials (Graphics)".
        <#{admin_metadata_term}> <http://id.loc.gov/ontologies/bibframe/descriptionConventions> <http://id.loc.gov/vocabulary/descriptionConventions/isbd>.
        <http://id.loc.gov/vocabulary/descriptionConventions/isbd> <http://www.w3.org/2000/01/rdf-schema#label> "ISBD: International Standard Bibliographic Description".
      TTL
    end

    let(:model) do
      {
        lccn: {},
        cataloging_source: {
          description_conventions: %w[dcrmg isbd]
        },
        geographic_area_code: {}
      }
    end

    include_examples 'mapper', described_class
  end

  describe 'geographic area codes' do
    let(:ttl) do
      <<~TTL
                                  <#{work_term}> <http://id.loc.gov/ontologies/bibframe/geographicCoverage> <http://id.loc.gov/authorities/names/n80046086>.
        <http://id.loc.gov/authorities/names/n80046086> <http://www.w3.org/2000/01/rdf-schema#label> "http://id.loc.gov/authorities/names/n80046086".
        <#{work_term}> <http://id.loc.gov/ontologies/bibframe/geographicCoverage> <http://id.loc.gov/authorities/names/n81097141>.
        <http://id.loc.gov/authorities/names/n81097141> <http://www.w3.org/2000/01/rdf-schema#label> "Shetland (Scotland)".
      TTL
    end

    let(:model) do
      {
        lccn: {},
        cataloging_source: {},
        geographic_area_code: {
          geographic_area_codes: %w[e-uk-st n-us-nj]
        }
      }
    end

    include_examples 'mapper', described_class
  end

  describe 'LC call numbers' do
    let(:ttl) do
      <<~TTL
                                  <#{work_term}> <http://id.loc.gov/ontologies/bibframe/classification> _:b36 .
        _:b36 <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> <http://id.loc.gov/ontologies/bibframe/ClassificationLcc> .
        _:b36 <http://id.loc.gov/ontologies/bibframe/classificationPortion> "QC861.2"@eng .
        <#{work_term}> <http://id.loc.gov/ontologies/bibframe/classification> _:b37 .
        _:b37 <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> <http://id.loc.gov/ontologies/bibframe/ClassificationLcc> .
        _:b37 <http://id.loc.gov/ontologies/bibframe/classificationPortion> "Z695.7"@eng .
        _:b37 <http://id.loc.gov/ontologies/bibframe/classificationPortion> "Z7164.N3"@eng .
        _:b37 <http://id.loc.gov/ontologies/bibframe/itemPortion> ".B37 1980"@eng .
        _:b37 <http://id.loc.gov/ontologies/bibframe/itemPortion> ".B36"@eng .
      TTL
    end

    let(:model) do
      {
        lccn: {},
        cataloging_source: {},
        geographic_area_code: {},
        lc_call_numbers: [
          {
            classification_numbers: ['QC861.2']
          },
          {
            classification_numbers: ['Z695.7', 'Z7164.N3'],
            item_number: '.B36'
          }
        ]
      }
    end

    include_examples 'mapper', described_class
  end
end
