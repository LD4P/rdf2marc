# frozen_string_literal: true

module Rdf2marc
  module Models
    module SubjectAccessField
      # Model for 655 - Index Term-Genre/Form.
      class GenreForm < Struct
        attribute :thesaurus, Types::String.default('not_specified').enum('lcsh', 'lcsh_childrens_literature', 'mesh', 'nal_subject_authority', 'not_specified', 'canadian_subject_headings', 'répertoire_de_vedettes-matière', 'subfield2')
        attribute? :genre_form_data, Types::String
        attribute? :form_subdivisions, Types::Array.of(Types::String)
        attribute? :general_subdivisions, Types::Array.of(Types::String)
        attribute? :chronological_subdivisions, Types::Array.of(Types::String)
        attribute? :geographic_subdivisions, Types::Array.of(Types::String)
        attribute? :term_source, Types::String
        attribute? :linkage, Types::String
        attribute? :field_links, Types::Array.of(Types::String)
      end
    end
  end
end
