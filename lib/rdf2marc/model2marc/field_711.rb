# frozen_string_literal: true

module Rdf2marc
  module Model2marc
    # Maps model to field 711.
    class Field711 < Field
      def initialize(marc_record, model)
        super(marc_record, model, '711')
      end

      def build
        field.indicator1 = name_type
        append('a', model.meeting_name)
        append_repeatable('c', model.meeting_locations)
        append_repeatable('d', model.meeting_dates)
        append_repeatable('e', model.subordinate_units)
        append('f', model.work_date)
        append_repeatable('g', model.misc_infos)
        append('h', model.medium)
        append_repeatable('j', model.relator_terms)
        append_repeatable('k', model.form_subheadings)
        append('l', model.work_language)
        append_repeatable('n', model.part_numbers)
        append_repeatable('p', model.part_names)
        append('q', model.following_meeting_name)
        append_repeatable('s', model.versions)
        append('t', model.work_title)
        append('u', model.affiliation)
        append('x', model.issn)
        append_repeatable('0', model.authority_record_control_numbers)
        append_repeatable('1', model.uris)
        append('2', model.source)
        append('3', model.materials_specified)
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
