# frozen_string_literal: true

RSpec.describe Rdf2marc::Model2marc::Leader do
  subject(:leader) { marc_record.marc_record.leader }

  let(:model) do
    {
      leader: {
        record_status: 'n',
        type: 'notated_music',
        bibliographic_level: 'serial_component',
        archival: false,
        encoding_level: 'full',
        cataloging_form: 'aacr2'
      },
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
      holdings_etc_fields: {}
    }
  end

  let(:record_model) { Rdf2marc::Models::Record.new(model) }

  let(:marc_record) { Rdf2marc::Model2marc::Record.new(record_model) }

  it 'maps to leader' do
    expect(leader).to eq('     ncb a22      a 4500')
  end
end
