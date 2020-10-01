# frozen_string_literal: true

module Rdf2marc
  module Models
    module HoldingsEtcField
      # Model for 884 - Description Conversion Information.
      class DescriptionConversionInfo < Struct
        attribute :conversion_process, Types::String
        attribute :conversion_date, Types::Date
        attribute :source_metadata_identifier, Types::String
        attribute? :conversion_agency, Types::String
        attribute :uri, Types::String
      end
    end
  end
end
