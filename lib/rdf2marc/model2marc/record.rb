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
          add_control_field('001', record_model.control_fields.control_number, marc_record)
          add_control_field('003', record_model.control_fields.control_number_id, marc_record)
          add_field(ControlField005, record_model.control_fields, marc_record)
          add_field(ControlField008, record_model.control_fields.general_info, marc_record)
          add_field(Field010, record_model.number_and_code_fields.lccn, marc_record)
          add_repeating_field(Field242, record_model.title_fields.translated_titles, marc_record)
          add_field(Field245, record_model.title_fields.title_statement, marc_record)
          add_repeating_field(Field246, record_model.title_fields.variant_titles, marc_record)
          add_repeating_field(Field247, record_model.title_fields.former_titles, marc_record)
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

      def add_control_field(tag, value, marc_record)
        marc_record << MARC::ControlField.new(tag,value) unless value.nil?
      end

    end
  end
end