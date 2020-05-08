module Rdf2marc
  module Model2marc
    class Field245
      def initialize(marc_record, model)
        @marc_record = marc_record
        @model = model
      end

      def generate
        marc_record << MARC::DataField.new('245').tap do |field|
          field.indicator1 = model.added_entry ? '1' : '0'
          field.indicator2 = model.nonfile_characters.to_s
          field.append(MARC::Subfield.new('a', model.title)) if model.title
          field.append(MARC::Subfield.new('b', model.remainder_of_title)) if model.remainder_of_title
          field.append(MARC::Subfield.new('c', model.statement_of_responsibility)) if model.statement_of_responsibility
          field.append(MARC::Subfield.new('h', clean_medium(model.medium))) if model.medium
        end
      end

      private

      attr_reader :marc_record, :model

      def clean_medium(medium)
        "[#{medium.downcase}]"
      end
    end
  end
end