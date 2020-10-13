# frozen_string_literal: true

module Rdf2marc
  module Model2marc
    # Maps model to field 856.
    class Field856 < Field
      def initialize(marc_record, model)
        super(marc_record, model, '856')
      end

      def build
        field.indicator1 = access_method
        append_repeatable('u', model.uris)
      end

      private

      def access_method
        case model.access_method
        when 'email'
          '0'
        when 'ftp'
          '1'
        when 'telnet'
          '2'
        when 'dial-up'
          '3'
        when 'http'
          '4'
        else
          ' '
        end
      end
    end
  end
end
