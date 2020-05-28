# frozen_string_literal: true

module Rdf2marc
  module Model2marc
    # Maps model to field 008.
    class ControlField008 < ControlField
      def initialize(marc_record, model)
        super(marc_record, model, '008')
      end

      def value
        field_value = ' ' * 40
        # Date entered on file
        field_value[0..5] = (model.date_entered || Date.today).strftime('%y%m%d')
        # Type of date, date1, date2
        if model.date1
          field_value[6..10] = "s#{formatted_date1}" if model.date1
        else
          field_value[6..14] = '|||||||||'
        end
        # Place of publication not yet supported. Would require doing lookup on URI.
        field_value[15..17] = 'xx '
        # Language
        field_value[35..37] = model.language[0..2] if model.language
        # Modified record
        field_value[38] = '|'
        # Cataloging source
        field_value[39] = '|'
        field_value
      end

      private

      def formatted_date1
        model.date1[0..4].gsub(/x/i, 'u')
      end
    end
  end
end
