# frozen_string_literal: true

require 'rdf2marc/resolver/id_loc_gov_resolvers/resolvers_shared_examples'

RSpec.describe Rdf2marc::Resolver::IdLocGovResolvers::GeographicName do
  context 'with a Geographic Subdivision (181, not 151)'
  let(:uri) { 'https://id.loc.gov/authorities/subjects/sh85045765-781' }

  let(:subfields) do
    [
      ['z', 'Europe, Eastern']
    ]
  end

  let(:model) do
    {
      authority_record_control_numbers: ['https://id.loc.gov/authorities/subjects/sh85045765-781'],
      thesaurus: 'lcsh',
      geographic_subdivisions: ['Europe, Eastern']
    }
  end

  include_examples 'resolver_mapper', described_class, '181', Rdf2marc::Models::SubjectAccessField::GeographicName
end
