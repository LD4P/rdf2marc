# frozen_string_literal: true

module Rdf2marc
  module Models
    module PhysicalDescriptionField
      class PhysicalDescription < Struct
        attribute? :extents, Types::Array.of(Types::String)
        attribute? :dimensions, Types::Array.of(Types::String)
        attribute? :materials_specified, Types::String
      end
    end
  end
end