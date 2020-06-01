# frozen_string_literal: true

module Rdf2marc
  module Model2marc
    # Maps model to field 260.
    class Field260 < Field
      def initialize(marc_record, model)
        super(marc_record, model, '260')
      end

      def build
        append_repeatable('a', model.publication_distribution_places)
        append_repeatable('b', model.publisher_distributor_names)
        append_repeatable('c', model.publication_distribution_dates)
        append_repeatable('e', model.manufacture_places)
        append_repeatable('f', model.manufacturer_names)
        append_repeatable('g', model.manufacture_dates)
      end
    end
  end
end
