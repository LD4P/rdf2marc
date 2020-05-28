# frozen_string_literal: true

module Rdf2marc
  module Models
    module NumberAndCodeField
      # Model for 043 - Geographic Area Code.
      class GeographicAreaCode < Struct
        attribute? :geographic_area_codes, Types::Array.of(Types::String)
      end
    end
  end
end
