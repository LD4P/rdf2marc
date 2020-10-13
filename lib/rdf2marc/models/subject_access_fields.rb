# frozen_string_literal: true

module Rdf2marc
  module Models
    # Model for 6XX: Subject Access Fields.
    class SubjectAccessFields < Struct
      attribute? :personal_names, Types::Array.of(General::PersonalName)
      attribute? :corporate_names, Types::Array.of(General::CorporateName)
      attribute? :meeting_names, Types::Array.of(General::MeetingName)
      attribute? :topical_terms, Types::Array.of(SubjectAccessField::TopicalTerm)
      attribute? :geographic_names, Types::Array.of(SubjectAccessField::GeographicName)
      attribute? :genre_forms, Types::Array.of(SubjectAccessField::GenreForm)
    end
  end
end
