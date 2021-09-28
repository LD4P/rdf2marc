# frozen_string_literal: true

RSpec.describe Rdf2marc::Model2marc::Record do
  subject(:marc_record) { described_class.new(record_model).to_s }

  let(:record_model) do
    Rdf2marc::Models::Record.new(
      leader: Rdf2marc::Models::Leader.new.to_h,
      control_fields: {
        general_info: {}
      },
      number_and_code_fields: {},
      main_entry_fields: {},
      title_fields: {},
      physical_description_fields: {},
      series_statement_fields: {},
      edition_imprint_fields: {},
      note_fields: {},
      subject_access_fields: {},
      added_entry_fields: {},
      holdings_etc_fields: {},
      work: { title: 'test title', uri: 'https://dev-api.sinopia.io' }
    )
  end

  before do
    allow(Date).to receive(:today).and_return(Date.new(2020, 10, 1))
  end

  it 'produces MARC' do
    expect(marc_record).to eq <<~MARC
      LEADER      nam a22     uu 4500
      008 201001|||||||||xx                     ||
      758    $4 http://id.loc.gov/ontologies/bibframe/instanceOf $i Instance of: $a test title $0 https://dev-api.sinopia.io#{' '}
    MARC
  end
end
