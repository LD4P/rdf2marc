# frozen_string_literal: true

module Rdf2marc
  module Model2marc
    # Maps model to field 043.
    class Field043 < Field
      def initialize(marc_record, model)
        super(marc_record, model, '043')
      end

      def build
        append_repeatable('a', model.geographic_area_codes)
      end
    end
  end
end
