# frozen_string_literal: true

module Rdf2marc
  module Model2marc
    # Maps model to field 651.
    class Field651 < Field
      def initialize(marc_record, model)
        super(marc_record, model, '651')
      end

      def build
        append('a', model.geographic_name)
        append_repeatable('0', model.authority_record_control_numbers)
      end
    end
  end
end
