module Rdf2marc
  module Model2marc
    class Field250 < Field
      def initialize(marc_record, model)
        super(marc_record, model, '250')
      end

      def build
        append('a', model.edition)
      end
    end
  end
end