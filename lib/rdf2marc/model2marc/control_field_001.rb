module Rdf2marc
  module Model2marc
    class ControlField001
      def initialize(marc_record, model)
        @marc_record = marc_record
        @model = model
      end

      def generate
        return if model.nil?

        marc_record << MARC::ControlField.new('001', model.control_number)
      end

      attr_reader :marc_record, :model
    end
  end
end