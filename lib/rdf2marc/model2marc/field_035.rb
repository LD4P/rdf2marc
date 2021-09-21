# frozen_string_literal: true

module Rdf2marc
  module Model2marc
    # Maps model to field 035.
    class Field035 < Field
      def initialize(marc_record, model)
        super(marc_record, model, '035')
      end

      def build
        append('a', "(OCoLC)#{model}")
      end
    end
  end
end
