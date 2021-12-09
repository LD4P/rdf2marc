# frozen_string_literal: true

module Rdf2marc
  module Models
    module PhysicalDescriptionField
      # Model for 300 - Physical Description.
      class PhysicalDescription < Struct
        attribute? :extents, Types::Array.of(Types::String)
        attribute? :other_physical_details, Types::String
        attribute? :dimensions, Types::Array.of(Types::String)
        attribute? :materials_specified, Types::String
      end
    end
  end
end
