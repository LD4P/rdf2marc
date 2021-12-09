# frozen_string_literal: true

module Rdf2marc
  module Model2marc
    # Maps model to field 245.
    class Field245 < Field
      def initialize(marc_record, model)
        super(marc_record, model, '245')
      end

      def build
        field.indicator1 = model.added_entry == 'added' ? '1' : '0'
        field.indicator2 = model.nonfile_characters.to_s
        append('a', model.title)
        append('b', model.remainder_of_title)
        # Subfields n and p should come before c.
        append_repeatable('n', model.part_numbers)
        append_repeatable('p', model.part_names)
        append('c', model.statement_of_responsibility)
      end
    end
  end
end
