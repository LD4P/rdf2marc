# frozen_string_literal: true

RSpec.describe Rdf2marc::Model2marc::Record do
  let(:record_model) { Rdf2marc::Models::Record.new }
  subject(:marc_record) { Rdf2marc::Model2marc::Record.new(record_model).to_s }

  before do
    allow(Date).to receive(:today).and_return(Date.new(2020, 10, 1))
  end

  it { is_expected.to eq "LEADER      nam a22     uu 4500\n008 201001|||||||||xx                     ||\n" }
end
