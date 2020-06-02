# frozen_string_literal: true

module Rdf2marc
  module Models
    module PhysicalDescriptionField
      # Model for 336 - Content Type.
      class ContentType < Struct
        attribute? :content_type_terms, Types::Array.of(Types::String)
        attribute? :content_type_codes, Types::Array.of(Types::String)
        attribute? :authority_control_number_uri, Types::String
        attribute? :source, Types::String.default('rdacontent')
      end
    end
  end
end
