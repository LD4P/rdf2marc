# frozen_string_literal: true

module Rdf2marc
  module Model2marc
    # Maps model to field 651.
    class Field651 < Field
      def initialize(marc_record, model)
        super(marc_record, model, '651')
      end

      def build
        field.indicator2 = Thesaurus.code_for(model.thesaurus)
        append('a', model.geographic_name)
        append_repeatable('v', model.form_subdivisions)
        append_repeatable('x', model.general_subdivisions)
        append_repeatable('y', model.chronological_subdivisions)
        append_repeatable('z', model.geographic_subdivisions)
        append('2', model.source)
        append_repeatable('0', model.authority_record_control_numbers)
        append_repeatable('1', model.uris)
        append('3', model.materials_specified)
        append('6', model.linkage)
        append_repeatable('8', model.field_links)
      end
    end
  end
end
