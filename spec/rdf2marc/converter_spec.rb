# frozen_string_literal: true

RSpec.describe Rdf2marc::Converter, :vcr do
  context 'with files' do
    subject { described_class.convert(files: files, cache: Rdf2marc::Caches::NullCache.new) }

    let(:files) { %w[instance.ttl work.ttl admin_metadata.ttl] }

    it { is_expected.to be_instance_of Rdf2marc::Models::Record }
  end

  context 'with a url' do
    subject { described_class.convert(url: source, cache: Rdf2marc::Caches::NullCache.new) }

    let(:source) { 'https://api.stage.sinopia.io/resource/70ac2ed7-95d0-492a-a300-050a40895b74' }

    it { is_expected.to be_instance_of Rdf2marc::Models::Record }
  end
end
