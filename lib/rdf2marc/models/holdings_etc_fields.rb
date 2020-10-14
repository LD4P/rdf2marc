# frozen_string_literal: true

module Rdf2marc
  module Models
    # Model for 841-88X - Holdings, Alternate Graphics, Etc.-General Information.
    class HoldingsEtcFields < Struct
      attribute? :description_conversion_infos, Types::Array.of(HoldingsEtcField::DescriptionConversionInfo)
      attribute? :electronic_locations, Types::Array.of(HoldingsEtcField::ElectronicLocation)
    end
  end
end
