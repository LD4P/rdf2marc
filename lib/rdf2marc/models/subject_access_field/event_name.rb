# frozen_string_literal: true

module Rdf2marc
  module Models
    module SubjectAccessField
      # Model for 647 - Named Event.
      # See https://www.loc.gov/marc/bibliographic/bd647.html
      class EventName < Struct
        attribute :thesaurus, Types::Thesaurus
        attribute? :name, Types::String
        attribute? :locations, Types::Array.of(Types::String)
        attribute? :date, Types::String
        attribute? :misc_infos, Types::Array.of(Types::String)
        attribute? :form_subdivisions, Types::Array.of(Types::String)
        attribute? :general_subdivisions, Types::Array.of(Types::String)
        attribute? :chronological_subdivisions, Types::Array.of(Types::String)
        attribute? :geographic_subdivisions, Types::Array.of(Types::String)
        attribute? :authority_record_control_numbers, Types::Array.of(Types::String)
        attribute? :source, Types::String
        attribute? :uris, Types::Array.of(Types::String)
        attribute? :materials_specified, Types::String
        attribute? :linkage, Types::String
        attribute? :field_links, Types::Array.of(Types::String)
      end
    end
  end
end
