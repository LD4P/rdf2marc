# frozen_string_literal: true

module Rdf2marc
  module Model2marc
    # Maps model to field 264.
    class Field264 < Field
      def initialize(marc_record, model)
        super(marc_record, model, '264')
      end

      def build
        field.indicator2 = entity_function
        append_repeatable('a', model.publication_distribution_places)
        append_repeatable('b', model.publisher_distributor_names)
        append_repeatable('c', model.publication_distribution_dates)
      end

      private

      def entity_function
        case model.entity_function
        when 'production'
          '0'
        when 'publication'
          '1'
        when 'distribution'
          '2'
        when 'manufacture'
          '3'
        when 'copyright_notice_date'
          '4'
        else
          ' '
        end
      end
    end
  end
end
