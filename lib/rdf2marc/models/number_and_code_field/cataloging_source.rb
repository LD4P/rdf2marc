# frozen_string_literal: true

module Rdf2marc
  module Models
    module NumberAndCodeField
      # Model for 040 - Cataloging Source.
      class CatalogingSource < Struct
        attribute? :cataloging_agency, Types::String
        attribute? :cataloging_language, Types::String
        attribute? :transcribing_agency, Types::String
        attribute? :modifying_agencies, Types::Array.of(Types::String)
        attribute? :description_conventions, Types::Array.of(Types::String)
      end
    end
  end
end
