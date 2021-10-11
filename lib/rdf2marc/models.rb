# frozen_string_literal: true

module Rdf2marc
  module Models
    # DRY Types
    module Types
      include Dry.Types()

      Thesaurus = String.default('not_specified').enum('lcsh',
                                                       'lcsh_childrens_literature',
                                                       'mesh',
                                                       'nal_subject_authority',
                                                       'not_specified',
                                                       'canadian_subject_headings',
                                                       'répertoire_de_vedettes-matière',
                                                       'subfield2')
    end

    # Base class for models.
    class Struct < Dry::Struct
      transform_keys(&:to_sym)

      schema schema.strict
    end
  end
end
