# frozen_string_literal: true

module Rdf2marc
  module Models
    module SubjectAccessField
      # Model for 655 - Index Term-Genre/Form.
      class GenreForm < Struct
        attribute :thesaurus, Types::Thesaurus
        attribute? :genre_form_data, Types::String
        attribute? :form_subdivisions, Types::Array.of(Types::String)
        attribute? :general_subdivisions, Types::Array.of(Types::String)
        attribute? :chronological_subdivisions, Types::Array.of(Types::String)
        attribute? :geographic_subdivisions, Types::Array.of(Types::String)
        attribute? :authority_record_control_numbers, Types::Array.of(Types::String)
        attribute? :uris, Types::Array.of(Types::String)
        attribute? :source, Types::String
        attribute? :materials_specified, Types::String
        attribute? :applies_to_institution, Types::String
        attribute? :linkage, Types::String
        attribute? :field_links, Types::Array.of(Types::String)
      end
    end
  end
end
