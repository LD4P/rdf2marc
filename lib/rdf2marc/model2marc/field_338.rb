# frozen_string_literal: true

module Rdf2marc
  module Model2marc
    # Maps model to field 338.
    class Field338 < Field
      def initialize(marc_record, model)
        super(marc_record, model, '338')
      end

      def build
        append_repeatable('a', model.carrier_type_terms)
        append_repeatable('b', model.carrier_type_codes)
        append('0', model.authority_control_number_uri)
        append('2', model.source)
      end
    end
  end
end
