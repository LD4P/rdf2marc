# frozen_string_literal: true

module Rdf2marc
  module Models
    module PhysicalDescriptionField
      # Model for 337 - Media Type.
      class MediaType < Struct
        attribute? :media_type_terms, Types::Array.of(Types::String)
        attribute? :media_type_codes, Types::Array.of(Types::String)
        attribute? :authority_control_number_uri, Types::String
        attribute? :source, Types::String.default('rdamedia')
      end
    end
  end
end
