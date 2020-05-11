module Rdf2marc
  module Model2marc
    class Field242 < Field
      def initialize(marc_record, model)
        super(marc_record, model, '242')
      end

      def build
        field.indicator1 =  model.added_entry == 'added' ? '1' : '0'
        field.indicator2 = model.nonfile_characters.to_s
        append('a', model.title)
        append('b', model.remainder_of_title)
        append_repeatable('n', model.part_numbers)
        append_repeatable('p', model.part_names)
      end
    end
  end
end