# frozen_string_literal: true

require 'rdf2marc/resolver/id_loc_gov_resolvers/resolvers_shared_examples'

RSpec.describe Rdf2marc::Resolver::IdLocGovResolvers::GenreForm do
  let(:uri) { 'http://id.loc.gov/authorities/genreForms/gf2011026321' }

  let(:subfields) do
    [
      ['a', 'Horror films'],
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
      thesaurus: 'subfield2',
      genre_form_data: 'Horror films',
      form_subdivisions: %w[Periodicals Newspapers],
      general_subdivisions: ['Salaries, etc.', 'Buddhism, [Christianity, etc.]'],
      chronological_subdivisions: ['19th century', 'Middle Ages, 600-1500'],
      geographic_subdivisions: ['Germany (West)', 'Kenya'],
      authority_record_control_numbers: ['http://id.loc.gov/authorities/genreForms/gf2011026321'],
      term_source: 'lcgft',
      linkage: '880-01',
      field_links: ['92.1\\p', '112.2\\u']
    }
  end

  include_examples 'resolver_mapper', described_class, '155', Rdf2marc::Models::SubjectAccessField::GenreForm
end
