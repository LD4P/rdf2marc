# frozen_string_literal: true

require 'rdf2marc/rdf2model/mappers/mappers_shared_examples'

RSpec.describe Rdf2marc::Rdf2model::Mappers::TitleFields do
  subject { mapper.generate.deep_compact }

  let(:item_context) do
    Rdf2marc::Rdf2model.item_context_for(graph, RDF::URI(instance_term), RDF::URI(work_term),
                                         RDF::URI(admin_metadata_term))
  end
  let(:graph) { RDF::Graph.new.from_ttl(ttl) }

  let(:instance_term) { 'https://api.sinopia.io/resource/test_instance' }
  let(:work_term) { 'https://api.sinopia.io/resource/test_work' }
  let(:admin_metadata_term) { 'https://api.sinopia.io/resource/test_admin_metadata' }

  let(:mapper) { described_class.new(item_context, has_100_field: true) }

  context 'with minimal graph' do
    let(:ttl) { '' }

    let(:model) do
      {}
    end

    it { is_expected.to eq model }
  end

  describe 'translated titles' do
    let(:ttl) do
      <<~TTL
        <#{instance_term}> <http://id.loc.gov/ontologies/bibframe/title> _:b666 .
        _:b666 a <http://id.loc.gov/ontologies/bflc/TransliteratedTitle>;
          <http://id.loc.gov/ontologies/bibframe/mainTitle> "Abḥathu ‘an Laylá"@ar-Latn-t-ar-m0-alaloc;
          <http://id.loc.gov/ontologies/bibframe/subtitle> "riwāyah"@ar-Latn-t-ar-m0-alaloc;
          <http://id.loc.gov/ontologies/bibframe/partName> "partName"@eng .
      TTL
    end

    let(:model) do
      {
        translated_titles: [
          {
            title: 'Abḥathu ‘an Laylá',
            remainder_of_title: 'riwāyah',
            part_names: ['partName']
          }
        ]
      }
    end

    it { is_expected.to eq model }
  end

  describe 'title statement' do
    # This contains an extra title, which is ignored.
    let(:ttl) do
      <<~TTL
               <#{instance_term}> <http://id.loc.gov/ontologies/bibframe/title> _:b43 .
            _:b43 <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> <http://id.loc.gov/ontologies/bibframe/Title> .
        _:b43 <http://id.loc.gov/ontologies/bibframe/mainTitle> "Distribution of the principal kinds of soil"@eng .
            _:b43 <http://id.loc.gov/ontologies/bibframe/subtitle> "orders, suborders, and great groups : National Soil Survey Classification of 1967"@eng .
            _:b43 <http://id.loc.gov/ontologies/bibframe/partNumber> "Part one"@eng .
            _:b43 <http://id.loc.gov/ontologies/bibframe/partNumber> "Part B"@eng .
            _:b43 <http://id.loc.gov/ontologies/bibframe/partName> "Student handbook"@eng .
            _:b43 <http://id.loc.gov/ontologies/bibframe/partName> "Supplement"@eng .
            <> <http://id.loc.gov/ontologies/bibframe/title> _:b44 .
            _:b44 <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> <http://id.loc.gov/ontologies/bibframe/Title> .
        _:b44 <http://id.loc.gov/ontologies/bibframe/mainTitle> "The royal gazette"@eng .
      TTL
    end

    context 'with a 1XX field' do
      let(:model) do
        {
          title_statement: {
            added_entry: 'added',
            part_names: ['Student handbook', 'Supplement'],
            part_numbers: ['Part B', 'Part one'],
            remainder_of_title: 'orders, suborders, and great groups : National Soil Survey Classification of 1967',
            title: 'Distribution of the principal kinds of soil'
          }
        }
      end

      it { is_expected.to eq model }
    end

    context 'without a 1XX field' do
      let(:mapper) { described_class.new(item_context, has_100_field: false) }

      let(:model) do
        {
          title_statement: {
            added_entry: 'no_added',
            part_names: ['Student handbook', 'Supplement'],
            part_numbers: ['Part B', 'Part one'],
            remainder_of_title: 'orders, suborders, and great groups : National Soil Survey Classification of 1967',
            title: 'Distribution of the principal kinds of soil'
          }
        }
      end

      it { is_expected.to eq model }
    end
  end

  describe 'variant titles' do
    let(:ttl) do
      <<~TTL
               <#{instance_term}> <http://id.loc.gov/ontologies/bibframe/title> _:b45 .
        _:b45 <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> <http://id.loc.gov/ontologies/bibframe/ParallelTitle> .
        _:b45 <http://id.loc.gov/ontologies/bibframe/mainTitle> "The Year book of medicine"@eng .
        _:b45 <http://id.loc.gov/ontologies/bibframe/subtitle> "facts or fiction"@eng .
        <#{instance_term}> <http://id.loc.gov/ontologies/bibframe/title> _:b46 .
        _:b46 <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> <http://id.loc.gov/ontologies/bibframe/VariantTitle> .
        _:b46 <http://id.loc.gov/ontologies/bibframe/mainTitle> "World of art"@eng .
        _:b46 <http://id.loc.gov/ontologies/bibframe/partName> "Selected Internet resources"@eng .
        _:b46 <http://id.loc.gov/ontologies/bibframe/partName> "Student handbook"@eng .
        _:b46 <http://id.loc.gov/ontologies/bibframe/variantType> "cover"@eng .
      TTL
    end

    let(:model) do
      {
        variant_titles: [
          {
            note_added_entry: 'no_note_added',
            title: 'The Year book of medicine',
            type: 'parallel'
          },
          {
            note_added_entry: 'note_added',
            part_names: ['Selected Internet resources', 'Student handbook'],
            title: 'World of art',
            type: 'cover'
          }
        ]
      }
    end

    it { is_expected.to eq model }
  end

  describe 'former titles' do
    let(:ttl) do
      <<~TTL
               <#{instance_term}> <http://id.loc.gov/ontologies/bibframe/title> _:b47.
        _:b47 a <http://id.loc.gov/ontologies/bibframe/VariantTitle>;
            <http://id.loc.gov/ontologies/bibframe/mainTitle> "World of art"@eng;
            <http://id.loc.gov/ontologies/bibframe/partName> "Selected Internet resources"@eng, "Student handbook"@eng;
            <http://id.loc.gov/ontologies/bibframe/variantType> "cover"@eng, "former"@eng.
      TTL
    end

    let(:model) do
      {
        former_titles: [
          {
            part_names: ['Selected Internet resources', 'Student handbook'],
            title: 'World of art'
          }
        ]
      }
    end

    it { is_expected.to eq model }
  end
end
