# frozen_string_literal: true

module Rdf2marc
  module Models
    module SubjectAccessField
      # Model for 650 - Topical Term.
      class TopicalTerm < Struct
        attribute :subject_level,
                  Types::String.default('not_provided').enum('not_provided', 'not_specified', 'primary', 'secondary')
        attribute :thesaurus, Types::Thesaurus
        attribute? :topical_term_or_geo_name, Types::String
        attribute? :topical_term_following_geo_name, Types::String
        attribute? :event_location, Types::String
        attribute? :dates, Types::String
        attribute? :relator_terms, Types::Array.of(Types::String)
        attribute? :misc_infos, Types::Array.of(Types::String)
        attribute? :form_subdivisions, Types::Array.of(Types::String)
        attribute? :general_subdivisions, Types::Array.of(Types::String)
        attribute? :chronological_subdivisions, Types::Array.of(Types::String)
        attribute? :geographic_subdivisions, Types::Array.of(Types::String)
        attribute? :authority_record_control_numbers, Types::Array.of(Types::String)
        attribute? :uris, Types::Array.of(Types::String)
        attribute? :source, Types::String
        attribute? :materials_specified, Types::String
        attribute? :relationships, Types::Array.of(Types::String)
        attribute? :linkage, Types::String
        attribute? :field_links, Types::Array.of(Types::String)
      end
    end
  end
end
