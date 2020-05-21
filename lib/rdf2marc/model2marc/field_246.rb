# frozen_string_literal: true

module Rdf2marc
  module Model2marc
    # Maps model to field 246.
    class Field246 < Field
      def initialize(marc_record, model)
        super(marc_record, model, '246')
      end

      def build
        field.indicator1 = indicator1
        field.indicator2 = indicator2
        append('a', model.title)
        append('b', model.remainder_of_title)
        append_repeatable('n', model.part_numbers)
        append_repeatable('p', model.part_names)
      end

      private

      def indicator1
        case model.note_added_entry
        when 'note_no_added'
          '0'
        when 'note_added'
          '1'
        when 'no_note_no_added'
          '2'
        when 'no_note_added'
          '3'
        else
          raise 'unexpected added entry'
        end
      end

      def indicator2
        case model.type
        when 'none'
          ' '
        when 'portion'
          '0'
        when 'parallel'
          '1'
        when 'distinctive'
          '2'
        when 'other'
          '3'
        when 'cover'
          '4'
        when 'added_title_page'
          '5'
        when 'caption'
          '6'
        when 'running'
          '7'
        when 'spine'
          '8'
        else
          raise 'unexpected type of title'
        end
      end
    end
  end
end
