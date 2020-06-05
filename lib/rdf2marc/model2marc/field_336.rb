# frozen_string_literal: true

module Rdf2marc
  module Model2marc
    # Maps model to field 336.
    class Field336 < Field
      def initialize(marc_record, model)
        super(marc_record, model, '336')
      end

      def build
        append_repeatable('a', model.content_type_terms)
        append_repeatable('c', model.content_type_codes)
        append('0', "(uri)#{model.authority_control_number_uri}") if model.authority_control_number_uri
        append('2', model.source)
      end
    end
  end
end