# frozen_string_literal: true

module Rdf2marc
  module Models
    module SubjectAccessField
      # Model for 651 - Subject Added Entry-Geographic Name.
      class GeographicName < Struct
        attribute :thesaurus, Types::String.default('not_specified').enum('lcsh',
                                                                          'lcsh_childrens_literature',
                                                                          'mesh',
                                                                          'nal_subject_authority',
                                                                          'not_specified',
                                                                          'canadian_subject_headings',
                                                                          'répertoire_de_vedettes-matière',
                                                                          'subfield2')
        attribute? :geographic_name, Types::String
        attribute? :form_subdivisions, Types::Array.of(Types::String)
        attribute? :general_subdivisions, Types::Array.of(Types::String)
        attribute? :chronological_subdivisions, Types::Array.of(Types::String)
        attribute? :geographic_subdivisions, Types::Array.of(Types::String)
        attribute? :authority_record_control_numbers, Types::Array.of(Types::String)
        attribute? :uris, Types::Array.of(Types::String)
        attribute? :source, Types::String
        attribute? :materials_specified, Types::String
        attribute? :linkage, Types::String
        attribute? :field_links, Types::Array.of(Types::String)
      end
    end
  end
end
