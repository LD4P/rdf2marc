# frozen_string_literal: true

module Rdf2marc
  module Model2marc
    # Maps model to MARC record.
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
          add_repeating_field(Field020, record_model.number_and_code_fields.isbns, marc_record)
          add_field(Field040, record_model.number_and_code_fields.cataloging_source, marc_record)
          add_field(Field043, record_model.number_and_code_fields.geographic_area_code, marc_record)
          add_repeating_field(Field050, record_model.number_and_code_fields.lc_call_numbers, marc_record)
          add_field(Field100, record_model.main_entry_fields.personal_name, marc_record)
          add_field(Field110, record_model.main_entry_fields.corporate_name, marc_record)
          add_field(Field111, record_model.main_entry_fields.meeting_name, marc_record)
          add_repeating_field(Field242, record_model.title_fields.translated_titles, marc_record)
          add_field(Field245, record_model.title_fields.title_statement, marc_record)
          add_repeating_field(Field246, record_model.title_fields.variant_titles, marc_record)
          add_repeating_field(Field247, record_model.title_fields.former_titles, marc_record)
          add_repeating_field(Field250, record_model.edition_imprint_fields.editions, marc_record)
          add_repeating_field(Field264, record_model.edition_imprint_fields.publication_distributions, marc_record)
          add_repeating_field(Field300, record_model.physical_description_fields.physical_descriptions, marc_record)
          add_repeating_field(Field336, record_model.physical_description_fields.content_types, marc_record)
          add_repeating_field(Field337, record_model.physical_description_fields.media_types, marc_record)
          add_repeating_field(Field338, record_model.physical_description_fields.carrier_types, marc_record)
          add_repeating_field(Field490, record_model.series_statement_fields.series_statements, marc_record)
          add_repeating_field(Field500, record_model.note_fields.general_notes, marc_record)
          add_repeating_field(Field600, record_model.subject_access_fields.personal_names, marc_record)
          add_repeating_field(Field610, record_model.subject_access_fields.corporate_names, marc_record)
          add_repeating_field(Field611, record_model.subject_access_fields.meeting_names, marc_record)
          add_repeating_field(Field651, record_model.subject_access_fields.geographic_names, marc_record)
          add_repeating_field(Field655, record_model.subject_access_fields.genre_forms, marc_record)
          add_repeating_field(Field700, record_model.added_entry_fields.personal_names, marc_record)
          add_repeating_field(Field710, record_model.added_entry_fields.corporate_names, marc_record)
          add_repeating_field(Field711, record_model.added_entry_fields.meeting_names, marc_record)
          add_repeating_field(Field856, record_model.holdings_etc_fields.electronic_locations, marc_record)
          add_repeating_field(Field884, record_model.holdings_etc_fields.description_conversion_infos, marc_record)
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
        marc_record << MARC::ControlField.new(tag, value) unless value.nil?
      end
    end
  end
end
