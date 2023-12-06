# frozen_string_literal: true

RSpec.describe Rdf2marc::Converter, :vcr do
  context 'with files' do
    subject { described_class.convert(files:) }

    let(:files) { %w[instance.ttl work.ttl admin_metadata.ttl] }

    it { is_expected.to be_instance_of Rdf2marc::Models::Record }
  end

  context 'with a url' do
    subject(:record) { described_class.convert(url: source) }

    let(:source) { 'https://api.stage.sinopia.io/resource/70ac2ed7-95d0-492a-a300-050a40895b74' }

    it 'mapped the fields' do
      expect(record.work.title).to eq 'Physica. English'
      expect(record.work.uri).to eq 'https://api.stage.sinopia.io/resource/ce0376a8-e01b-4829-95c2-c7aa4fa9568c'
    end
  end

  context 'when repository load fails' do
    let(:files) { %w[instance.ttl] }

    before do
      allow(RDF::Repository).to receive(:load).and_raise('uh oh!')
    end

    it 'raises a BadRequestError' do
      expect { described_class.convert(files:) }.to raise_error(
        Rdf2marc::BadRequestError,
        "Unable to load #{files.first}"
      )
    end
  end
end
