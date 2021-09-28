# frozen_string_literal: true

module Rdf2marc
  module Model2marc
    # Maps model to field 650.
    class Field650 < Field
      def initialize(marc_record, model)
        super(marc_record, model, '650')
      end

      def build
        field.indicator1 = subject_level
        field.indicator2 = thesaurus
        append('a', model.topical_term_or_geo_name)
        append('b', model.topical_term_following_geo_name)
        append('c', model.event_location)
        append('d', model.dates)
        append_repeatable('e', model.relator_terms)
        append_repeatable('g', model.misc_infos)
        append_repeatable('v', model.form_subdivisions)
        append_repeatable('x', model.general_subdivisions)
        append_repeatable('y', model.chronological_subdivisions)
        append_repeatable('z', model.geographic_subdivisions)
        append('2', model.heading_source)
        append_repeatable('0', model.authority_record_control_numbers)
        append_repeatable('1', model.uris)
        append('3', model.materials_specified)
        append_repeatable('4', model.relationships)
        append('6', model.linkage)
        append_repeatable('8', model.field_links)
      end

      private

      # See https://www.loc.gov/marc/bibliographic/bd650.html
      SUBJECT_LEVEL = {
        'not_provided' => ' ',
        'not_specified' => '0',
        'primary' => '1',
        'secondary' => '2'
      }.freeze

      def subject_level
        SUBJECT_LEVEL.fetch(model.subject_level)
      end

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
