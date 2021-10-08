# frozen_string_literal: true

module Rdf2marc
  module Models
    module SubjectAccessField
      # Model for 647 - Named Event.
      # See https://www.loc.gov/marc/bibliographic/bd647.html
      class EventName < Struct
        attribute :thesaurus, Types::Thesaurus
        attribute? :name, Types::String
        attribute? :source, Types::String
        attribute? :uris, Types::Array.of(Types::String)
      end
    end
  end
end
