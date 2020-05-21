# frozen_string_literal: true

module Rdf2marc
  module Model2marc
    # Maps model to field 100.
    class Field100 < Field
      def initialize(marc_record, model)
        super(marc_record, model, '100')
      end

      def build
        field.indicator1 = name_type
        append('a', model.personal_name)
        append('b', model.numeration)
        append_repeatable('c', model.title_and_words)
        append('d', model.dates)
        append_repeatable('e', model.relator_terms)
        append('f', model.work_date)
        append_repeatable('g', model.misc_infos)
        append_repeatable('j', model.attribution_qualifiers)
        append_repeatable('k', model.form_subheadings)
        append('l', model.work_language)
        append_repeatable('n', model.part_numbers)
        append_repeatable('p', model.part_names)
        append('q', model.fuller_form)
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
        when 'forename'
          '0'
        when 'surname'
          '1'
        else
          '3'
        end
      end
    end
  end
end
