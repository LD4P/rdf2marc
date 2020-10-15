# frozen_string_literal: true

module Rdf2marc
  module Model2marc
    # Maps model to field 655.
    class Field655 < Field
      def initialize(marc_record, model)
        super(marc_record, model, '655')
      end

      def build
        field.indicator2 = thesaurus
        append('a', model.genre_form_data)
        append_repeatable('v', model.form_subdivisions)
        append_repeatable('x', model.general_subdivisions)
        append_repeatable('y', model.chronological_subdivisions)
        append_repeatable('z', model.geographic_subdivisions)
        append_repeatable('0', model.authority_record_control_numbers)
        append_repeatable('1', model.uris)
        append('2', model.term_source)
        append('3', model.materials_specified)
        append('5', model.applies_to_institution)
        append('6', model.linkage)
        append_repeatable('8', model.field_links)
      end

      private

      def thesaurus
        case model.thesaurus
        when 'lcsh'
          '0'
        when 'lcsh_childrens_literature'
          '1'
        when 'mesh'
          '2'
        when 'nal_subject_authority'
          '3'
        when 'canadian_subject_headings'
          '5'
        when 'répertoire_de_vedettes-matière'
          '6'
        when 'subfield2'
          '7'
        else
          '4'
        end
      end
    end
  end
end
