# frozen_string_literal: true

require 'rdf2marc/resolver/id_loc_gov_resolvers/resolvers_shared_examples'

RSpec.describe Rdf2marc::Resolver::IdLocGovResolvers::MeetingName do
  let(:uri) { 'http://id.loc.gov/authorities/names/no2008005541' }

  let(:subfields) do
    [
      ['a', 'International Bigfoot Symposium'],
      ['b', 'Dept. of Human Services'],
      %w[b Conference],
      ['c', 'Rome, Italy'],
      %w[c Waco],
      %w[d 1950],
      ['d', '1682 Apr. 20'],
      ['e', 'Education Section'],
      ['e', 'Man/Machine Interface Committee'],
      %w[f 1982],
      %w[g Republican],
      %w[g Poland],
      ['h', 'Sound recording'],
      %w[j sponsor],
      %w[j patron],
      %w[k Selections],
      ['k', 'Spurious and doubtful works'],
      ['l', 'English & French'],
      ['n', 'Part 1'],
      ['n', 'Section 2'],
      %w[p Meditation],
      ['p', 'Cantiones sacrae'],
      ['q', 'International Biennial Exhibition of Art'],
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
      meeting_name: 'International Bigfoot Symposium',
      meeting_locations: ['Rome, Italy', 'Waco'],
      meeting_dates: ['1950', '1682 Apr. 20'],
      subordinate_units: ['Education Section', 'Man/Machine Interface Committee'],
      work_date: '1982',
      misc_infos: %w[Republican Poland],
      medium: 'Sound recording',
      relator_terms: %w[sponsor patron],
      form_subheadings: ['Selections', 'Spurious and doubtful works'],
      work_language: 'English & French',
      part_numbers: ['Part 1', 'Section 2'],
      part_names: ['Meditation', 'Cantiones sacrae'],
      following_meeting_name: 'International Biennial Exhibition of Art',
      versions: ['Vocal score', 'Texts'],
      work_title: 'Control de cambio no. 3',
      form_subdivisions: %w[Periodicals Newspapers],
      general_subdivisions: ['Salaries, etc.', 'Buddhism, [Christianity, etc.]'],
      chronological_subdivisions: ['19th century', 'Middle Ages, 600-1500'],
      geographic_subdivisions: ['Germany (West)', 'Kenya'],
      authority_record_control_numbers: ['http://id.loc.gov/authorities/names/no2008005541'],
      linkage: '880-01',
      field_links: ['92.1\\p', '112.2\\u']
    }
  end

  include_examples 'mapper', described_class, '111', Rdf2marc::Models::General::MeetingName
end
