# frozen_string_literal: true

module Rdf2marc
  module Model2marc
    # Maps model to field 490.
    class Field490 < Field
      def initialize(marc_record, model)
        super(marc_record, model, '490')
      end

      def build
        field.indicator1 = model.tracing_policy == 'traced' ? '1' : '0'
        append_repeatable('a', model.series_statements)
      end
    end
  end
end
