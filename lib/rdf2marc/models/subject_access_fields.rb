# frozen_string_literal: true

module Rdf2marc
  module Models
    # Model for 6XX: Subject Access Fields.
    class SubjectAccessFields < Struct
      attribute? :personal_names, Types::Array.of(SubjectAccessField::PersonalName)
      attribute? :corporate_names, Types::Array.of(SubjectAccessField::CorporateName)
    end
  end
end
