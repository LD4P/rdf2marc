# frozen_string_literal: true

module Rdf2marc
  module Model2marc
    # Maps model to field 050.
    class Field050 < Field
      def initialize(marc_record, model)
        super(marc_record, model, '050')
      end

      def build
        field.indicator2 = model.assigned_by == 'lc' ? '0' : '4'
        append_repeatable('a', model.classification_numbers)
        append('b', model.item_number)
      end
    end
  end
end
