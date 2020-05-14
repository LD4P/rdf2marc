module Rdf2marc
  module Model2marc
    class Field010 < Field
      def initialize(marc_record, model)
        super(marc_record, model, '010')
      end

      def build
        append('a', model.lccn)
        append_repeatable('z', model.cancelled_lccns)
      end
    end
  end
end