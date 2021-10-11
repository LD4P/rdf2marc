# frozen_string_literal: true

module Rdf2marc
  module Model2marc
    # Maps model to field 647.
    class Field647 < Field
      def initialize(marc_record, model)
        super(marc_record, model, '647')
      end

      def build
        field.indicator2 = Thesaurus.code_for(model.thesaurus)
        append('a', model.name)
        append('2', model.source)
        append_repeatable('0', model.uris)
      end
    end
  end
end
