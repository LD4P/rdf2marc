# frozen_string_literal: true

require 'rdf2marc/resolver/id_loc_gov_resolvers/resolvers_shared_examples'

RSpec.describe Rdf2marc::Resolver::IdLocGovResolvers::PersonalName do
  let(:uri) { 'http://id.loc.gov/authorities/names/n85164863' }

  let(:subfields) do
    [
      ['a', 'Manya K\'Omalowete a Djonga'],
      %w[b II],
      ['d', '1950-'],
      %w[f 1982],
      ['h', 'Sound recording'],
      ['j', 'follower of'],
      ['j', 'pupil of'],
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
      ['q', '(Sergei Dmitrievich)'],
      ['r', 'E major'],
      ['s', 'Vocal score'],
      %w[s Texts],
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

  let(:indicator1) { '3' }

  let(:model) do
    {
      type: 'family_name',
      thesaurus: 'lcsh',
      personal_name: "Manya K'Omalowete a Djonga",
      numeration: 'II',
      dates: '1950-',
      work_date: '1982',
      medium: 'Sound recording',
      attribution_qualifiers: ['follower of', 'pupil of'],
      form_subheadings: ['Selections', 'Spurious and doubtful works'],
      work_language: 'English & French',
      music_performance_mediums: %w[piano trumpet],
      part_numbers: ['Part 1', 'Section 2'],
      music_arranged_statement: 'arr.',
      part_names: ['Meditation', 'Cantiones sacrae'],
      fuller_form: '(Sergei Dmitrievich)',
      music_key: 'E major',
      versions: ['Vocal score', 'Texts'],
      form_subdivisions: %w[Periodicals Newspapers],
      general_subdivisions: ['Salaries, etc.', 'Buddhism, [Christianity, etc.]'],
      chronological_subdivisions: ['19th century', 'Middle Ages, 600-1500'],
      geographic_subdivisions: ['Germany (West)', 'Kenya'],
      authority_record_control_numbers: ['http://id.loc.gov/authorities/names/n85164863'],
      linkage: '880-01',
      field_links: ['92.1\\p', '112.2\\u']
    }
  end

  include_examples 'resolver_mapper', described_class, '100', Rdf2marc::Models::General::PersonalName
end
