# frozen_string_literal: true

require 'rdf2marc/resolver/id_loc_gov_resolvers/resolvers_shared_examples'

RSpec.describe Rdf2marc::Resolver::IdLocGovResolvers::CorporateName do
  let(:uri) { 'http://id.loc.gov/authorities/names/n2017061610' }

  let(:subfields) do
    [
      ['a', 'Alphabet Inc.'],
      ['b', 'Dept. of Human Services'],
      %w[b Conference],
      ['c', 'Rome, Italy'],
      %w[c Waco],
      %w[d 1950],
      ['d', '1682 Apr. 20'],
      %w[f 1982],
      %w[g Republican],
      %w[g Poland],
      ['h', 'Sound recording'],
      %w[k Selections],
      ['k', 'Spurious and doubtful works'],
      ['l', 'English & French'],
      %w[m piano],
      %w[m trumpet],
      ['n', 'Part 1'],
      ['n', 'Section 2'],
      ['o', 'arr.'],
      %w[p Meditation],
      ['p', 'Cantiones sacrae'],
      ['r', 'E major'],
      ['s', 'Vocal score'],
      %w[s Texts],
      ['t', 'Control de cambio no. 3'],
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

  let(:indicator1) { '2' }

  let(:model) do
    {
      type: 'direct',
      thesaurus: 'lcsh',
      corporate_name: 'Alphabet Inc.',
      subordinate_units: ['Dept. of Human Services', 'Conference'],
      meeting_locations: ['Rome, Italy', 'Waco'],
      meeting_dates: ['1950', '1682 Apr. 20'],
      work_date: '1982',
      misc_infos: %w[Republican Poland],
      medium: 'Sound recording',
      form_subheadings: ['Selections', 'Spurious and doubtful works'],
      work_language: 'English & French',
      music_performance_mediums: %w[piano trumpet],
      part_numbers: ['Part 1', 'Section 2'],
      music_arranged_statement: 'arr.',
      part_names: ['Meditation', 'Cantiones sacrae'],
      music_key: 'E major',
      versions: ['Vocal score', 'Texts'],
      work_title: 'Control de cambio no. 3',
      form_subdivisions: %w[Periodicals Newspapers],
      general_subdivisions: ['Salaries, etc.', 'Buddhism, [Christianity, etc.]'],
      chronological_subdivisions: ['19th century', 'Middle Ages, 600-1500'],
      geographic_subdivisions: ['Germany (West)', 'Kenya'],
      authority_record_control_numbers: ['http://id.loc.gov/authorities/names/n2017061610'],
      linkage: '880-01',
      field_links: ['92.1\\p', '112.2\\u']
    }
  end

  include_examples 'resolver_mapper', described_class, '110', Rdf2marc::Models::General::CorporateName
end
