# frozen_string_literal: true

module Rdf2marc
  module Model2marc
    # Maps model to field 505
    class Field505 < Field
      def initialize(marc_record, value)
        super(marc_record, value, '505')
      end

      def build
        field.indicator1 = '0'
        append('a', model)
      end
    end
  end
end
