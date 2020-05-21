# frozen_string_literal: true

module Rdf2marc
  module Models
    # Model for 3XX: Physical Description, Etc. Fields.
    class PhysicalDescriptionFields < Struct
      attribute? :physical_descriptions, Types::Array.of(PhysicalDescriptionField::PhysicalDescription)
    end
  end
end
