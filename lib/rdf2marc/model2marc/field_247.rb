# frozen_string_literal: true

module Rdf2marc
  module Model2marc
    # Maps model to field 247.
    class Field247 < Field
      def initialize(marc_record, model)
        super(marc_record, model, '247')
      end

      def build
        field.indicator1 = model.added_entry == 'added' ? '1' : '0'
        field.indicator2 = model.note_controller == 'no_display' ? '1' : '0'
        append('a', model.title)
        append('b', model.remainder_of_title)
        append_repeatable('n', model.part_numbers)
        append_repeatable('p', model.part_names)
      end
    end
  end
end
