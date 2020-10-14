# frozen_string_literal: true

require 'rdf2marc/rdf2model/mappers/mappers_shared_examples'

RSpec.describe Rdf2marc::Rdf2model::Mappers::TitleFields do
  context 'with minimal graph' do
    let(:ttl) { '' }

    let(:model) do
      {}
    end

    include_examples 'mapper', described_class
  end

  describe 'translated titles' do
    let(:ttl) do
      <<~TTL
               <#{instance_term}> <http://id.loc.gov/ontologies/bibframe/title> _:b41.
        _:b41 a <http://id.loc.gov/ontologies/bibframe/VariantTitle>;
          <http://id.loc.gov/ontologies/bibframe/mainTitle> "World of art"@eng;
          <http://id.loc.gov/ontologies/bibframe/partName> "Selected Internet resources"@eng, "Student handbook"@eng;
          <http://id.loc.gov/ontologies/bibframe/variantType> "translated"@eng, "acronym"@eng.
      TTL
    end

    let(:model) do
      {
        translated_titles: [
          {
            part_names: ['Selected Internet resources', 'Student handbook'],
            title: 'World of art'
          }
        ]
      }
    end
    include_examples 'mapper', described_class
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

    let(:model) do
      {
        title_statement: {
          part_names: ['Student handbook', 'Supplement'],
          part_numbers: ['Part B', 'Part one'],
          remainder_of_title: 'orders, suborders, and great groups : National Soil Survey Classification of 1967',
          title: 'Distribution of the principal kinds of soil'
        }
      }
    end
    include_examples 'mapper', described_class
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
    include_examples 'mapper', described_class
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
    include_examples 'mapper', described_class
  end
end
