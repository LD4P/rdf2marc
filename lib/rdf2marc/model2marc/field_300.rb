module Rdf2marc
  module Model2marc
    class Field300 < Field
      def initialize(marc_record, model)
        super(marc_record, model, '300')
      end

      def build
        append_repeatable('a', model.extents)
        append_repeatable('c', model.dimensions)
        append('3', model.materials_specified)
      end
    end
  end
end