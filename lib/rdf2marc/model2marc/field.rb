module Rdf2marc
  module Model2marc
    class Field
      def initialize(marc_record, model, tag)
        @marc_record = marc_record
        @model = model
        @field = MARC::DataField.new(tag)
      end

      def generate
        return if model.nil?

        build
        marc_record << field unless field.subfields.empty?
      end

      def build
        raise NotImplementedError
      end

      protected

      attr_reader :marc_record, :model, :field

      def append(subfield, value, pattern: nil)
        return if value.nil?

        raise "#{subfield} is not repeatable, but received an array" if value.is_a?(Array)

        field.append(MARC::Subfield.new(subfield, formatted_value(value, pattern)))
      end

      def append_repeatable(subfield, value, pattern: nil)
        return if value.nil?

        raise "#{subfield} is repeatable, but did not receive an array" unless value.is_a?(Array)
        value.each {|value_item| field.append(MARC::Subfield.new(subfield, formatted_value(value_item, pattern))) }
      end

      def formatted_value(value, pattern)
        return value if pattern.nil?

        eval('"' + pattern + '"')
      end
    end
  end
end