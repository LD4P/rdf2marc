# frozen_string_literal: true

module Rdf2marc
  module Model2marc
    # Maps model to field 040.
    class Field040 < Field
      def initialize(marc_record, model)
        super(marc_record, model, '040')
      end

      def build
        append('a', model.cataloging_agency)
        append('b', model.cataloging_language)
        append('c', model.transcribing_agency)
        append_repeatable('d', model.modifying_agencies)
        append_repeatable('e', model.description_conventions)
      end
    end
  end
end
