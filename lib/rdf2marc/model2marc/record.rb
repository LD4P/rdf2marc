module Rdf2marc
  module Model2marc
    class Record
      delegate :to_s, :to_marc, to: :marc_record

      def initialize(record_model)
        @record_model = record_model
      end

      def marc_record
        @marc_record ||= MARC::Record.new.tap do |marc_record|
          Leader.new(marc_record, record_model.leader).generate
          add_repeating_field(Field242, record_model.translated_titles, marc_record)
          add_field(Field245, record_model.title_statement, marc_record)
          add_repeating_field(Field246, record_model.variant_titles, marc_record)
          add_repeating_field(Field247, record_model.former_titles, marc_record)
        end
      end

      private

      attr_reader :record_model

      def add_field(field_class, model, marc_record)
        return if model.nil?

        field_class.new(marc_record, model).generate
      end

      def add_repeating_field(field_class, models, marc_record)
        return if models.nil?

        models.each { |model| add_field(field_class, model, marc_record) }
      end
    end
  end
end