# frozen_string_literal: true

module Rdf2marc
  module Model2marc
    # Maps model to field 500.
    class Field500 < Field
      def initialize(marc_record, model)
        super(marc_record, model, '500')
      end

      def build
        append('a', model.general_note)
      end
    end
  end
end
