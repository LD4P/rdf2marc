module Rdf2marc
  module Model2marc
    class Record
      def initialize(record_model)
        @record_model = record_model
      end

      def marc_record
        @marc_record ||= MARC::Record.new.tap do |marc_record|
          Field245.new(marc_record, record_model.title_statement).generate if record_model.title_statement
        end
      end

      def to_marc
        marc_record.to_marc
      end

      def to_s
        marc_record.to_s
      end

      private

      attr_reader :record_model

    end
  end
end