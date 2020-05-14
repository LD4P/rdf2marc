module Rdf2marc
  module Model2marc
    class ControlField
      def initialize(marc_record, model, tag)
        @marc_record = marc_record
        @model = model
        @tag = tag
      end

      def generate
        return if model.nil?

        field_value = value
        marc_record << MARC::ControlField.new(tag, field_value) unless field_value.nil?
      end

      def value
        raise NotImplementedError
      end

      protected

      attr_reader :marc_record, :model, :tag
    end
  end
end