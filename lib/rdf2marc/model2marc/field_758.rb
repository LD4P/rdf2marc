# frozen_string_literal: true

module Rdf2marc
  module Model2marc
    # Maps model to field 758.
    class Field758
      def initialize(marc_record, model)
        @marc_record = marc_record
        @url = model.holdings_etc_fields.description_conversion_infos&.first&.source_metadata_identifier
        @title = model.title_fields.title_statement&.title
        @field = MARC::DataField.new('758')
      end

      def generate
        return unless url && title

        build
        marc_record << field unless field.subfields.empty?
      end

      def build
        append('4', 'http://id.loc.gov/ontologies/bibframe/instanceOf')
        append('e', 'Instance of:')
        append('a', title)
        append('1', url)
      end

      private

      attr_reader :url, :title, :marc_record, :field

      def append(subfield, value)
        field.append(MARC::Subfield.new(subfield, value))
      end
    end
  end
end
