# frozen_string_literal: true

module Rdf2marc
  module Model2marc
    # Maps model to field 758.
    class Field758 < Field
      def initialize(marc_record, model)
        super(marc_record, model, '758')
      end

      def build
        append('4', 'http://id.loc.gov/ontologies/bibframe/instanceOf')
        append('i', 'Instance of:')
        append('a', model.title)
        append('0', model.uri)
      end
    end
  end
end
