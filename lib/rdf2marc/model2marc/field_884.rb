# frozen_string_literal: true

module Rdf2marc
  module Model2marc
    # Maps model to field 884.
    class Field884 < Field
      def initialize(marc_record, model)
        super(marc_record, model, '884')
      end

      def build
        append('a', model.conversion_process)
        append('g', model.conversion_date.strftime('%Y%m%d'))
        append('k', model.source_metadata_identifier)
        append('q', model.conversion_agency)
        append('u', model.uri)
      end
    end
  end
end
