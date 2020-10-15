# frozen_string_literal: true

RSpec.shared_examples 'fields' do |tag|
  subject(:fields) { marc_record.marc_record.fields(tag).map { |field| field.to_s.rstrip } }

  let(:base_model) do
    {
      leader: {},
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

  let(:record_model) { Rdf2marc::Models::Record.new(base_model.merge(model)) }
  let(:marc_record) { Rdf2marc::Model2marc::Record.new(record_model) }

  it 'maps to fields' do
    expect(fields).to eq(expected_fields)
  end
end
