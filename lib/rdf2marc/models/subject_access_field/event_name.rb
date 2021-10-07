# frozen_string_literal: true

module Rdf2marc
  module Models
    module SubjectAccessField
      # Model for 647 - Named Event.
      # See https://www.loc.gov/marc/bibliographic/bd647.html
      class EventName < Struct
        attribute :thesaurus, Types::String.default('not_specified').enum('lcsh',
                                                                          'lcsh_childrens_literature',
                                                                          'mesh',
                                                                          'nal_subject_authority',
                                                                          'not_specified',
                                                                          'canadian_subject_headings',
                                                                          'répertoire_de_vedettes-matière',
                                                                          'subfield2')
        attribute? :name, Types::String
        attribute? :source, Types::String
        attribute? :uris, Types::Array.of(Types::String)
      end
    end
  end
end
