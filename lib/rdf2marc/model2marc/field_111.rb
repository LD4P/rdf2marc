# frozen_string_literal: true

module Rdf2marc
  module Model2marc
    # Maps model to field 111.
    class Field111 < Field
      def initialize(marc_record, model)
        super(marc_record, model, '111')
      end

      def build
        field.indicator1 = name_type
        append('a', model.meeting_name)
        append_repeatable('c', model.meeting_locations)
        append_repeatable('d', model.meeting_dates)
        append_repeatable('e', model.subordinate_units)
        append('f', model.work_date)
        append_repeatable('g', model.misc_infos)
        append_repeatable('j', model.relator_terms)
        append_repeatable('k', model.form_subheadings)
        append('l', model.work_language)
        append_repeatable('n', model.part_numbers)
        append_repeatable('p', model.part_names)
        append('q', model.following_meeting_name)
        append('t', model.work_title)
        append('u', model.affiliation)
        append_repeatable('0', model.authority_record_control_numbers)
        append('1', model.uri)
        append('2', model.heading_source)
        append_repeatable('4', model.relationships)
        append('6', model.linkage)
        append_repeatable('8', model.field_links)
      end

      private

      def name_type
        case model.type
        when 'inverted'
          '0'
        when 'jurisdiction'
          '1'
        when 'direct'
          '2'
        else
          ' '
        end
      end
    end
  end
end
