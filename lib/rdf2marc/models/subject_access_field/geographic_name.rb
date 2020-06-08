# frozen_string_literal: true

module Rdf2marc
  module Models
    module SubjectAccessField
      # Model for 651 - Subject Added Entry-Geographic Name.
      class GeographicName < Struct
        attribute? :geographic_name, Types::String
        attribute? :authority_record_control_numbers, Types::Array.of(Types::String)
      end
    end
  end
end
