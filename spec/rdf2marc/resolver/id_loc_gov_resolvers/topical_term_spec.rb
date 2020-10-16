# frozen_string_literal: true

require 'rdf2marc/resolver/id_loc_gov_resolvers/resolvers_shared_examples'

RSpec.describe Rdf2marc::Resolver::IdLocGovResolvers::TopicalTerm do
  let(:uri) { 'http://id.loc.gov/authorities/subjects/sh85061211' }

  let(:subfields) do
    [
      %w[a Historiography],
      ['b', 'Lincoln Memorial'],
      %w[g Bodenkunde],
      %w[g Politik],
      %w[v Periodicals],
      %w[v Newspapers],
      ['x', 'Salaries, etc.'],
      ['x', 'Buddhism, [Christianity, etc.]'],
      ['y', '19th century'],
      ['y', 'Middle Ages, 600-1500'],
      ['z', 'Germany (West)'],
      %w[z Kenya],
      %w[6 880-01],
      ['8', '92.1\p'],
      ['8', '112.2\u']
    ]
  end

  let(:model) do
    {
      topical_term_or_geo_name: 'Historiography',
      topical_term_following_geo_name: 'Lincoln Memorial',
      misc_infos: %w[Bodenkunde Politik],
      form_subdivisions: %w[Periodicals Newspapers],
      general_subdivisions: ['Salaries, etc.', 'Buddhism, [Christianity, etc.]'],
      chronological_subdivisions: ['19th century', 'Middle Ages, 600-1500'],
      geographic_subdivisions: ['Germany (West)', 'Kenya'],
      authority_record_control_numbers: ['http://id.loc.gov/authorities/subjects/sh85061211'],
      linkage: '880-01',
      field_links: ['92.1\\p', '112.2\\u']
    }
  end

  include_examples 'mapper', described_class, '150', Rdf2marc::Models::SubjectAccessField::TopicalTerm
end
