# frozen_string_literal: true

module Rdf2marc
  module Model2marc
    # Maps model to field 655.
    class Field655 < Field
      def initialize(marc_record, model)
        super(marc_record, model, '655')
      end

      def build
        field.indicator2 = Thesaurus.code_for(model.thesaurus)
        append('a', model.genre_form_data)
        append_repeatable('v', model.form_subdivisions)
        append_repeatable('x', model.general_subdivisions)
        append_repeatable('y', model.chronological_subdivisions)
        append_repeatable('z', model.geographic_subdivisions)
        append_repeatable('0', model.authority_record_control_numbers)
        append_repeatable('1', model.uris)
        append('2', model.source)
        append('3', model.materials_specified)
        append('5', model.applies_to_institution)
        append('6', model.linkage)
        append_repeatable('8', model.field_links)
      end
    end
  end
end
