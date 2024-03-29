# frozen_string_literal: true

require 'rdf2marc/resolver/marc_mappers/resolvers_shared_examples'

RSpec.describe Rdf2marc::Resolver::MarcMappers::EventName do
  let(:uri) { 'http://id.loc.gov/authorities/names/no2008005541' }

  let(:subfields) do
    [
      ['a', 'Sino-Japanese War'],
      ['c', 'Rome, Italy'],
      %w[c Waco],
      ['d', '1682 Apr. 20'],
      %w[g Republican],
      %w[g Poland],
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
      name: 'Sino-Japanese War',
      locations: ['Rome, Italy', 'Waco'],
      date: '1682 Apr. 20',
      misc_infos: %w[Republican Poland],
      form_subdivisions: %w[Periodicals Newspapers],
      general_subdivisions: ['Salaries, etc.', 'Buddhism, [Christianity, etc.]'],
      chronological_subdivisions: ['19th century', 'Middle Ages, 600-1500'],
      geographic_subdivisions: ['Germany (West)', 'Kenya'],
      authority_record_control_numbers: ['http://id.loc.gov/authorities/names/no2008005541'],
      linkage: '880-01',
      field_links: ['92.1\\p', '112.2\\u']
    }
  end

  include_examples 'resolver_mapper', described_class, '147', Rdf2marc::Models::SubjectAccessField::EventName
end
