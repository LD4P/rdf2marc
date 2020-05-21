# frozen_string_literal: true

module Rdf2marc
  module Models
    # Model for 70X-75X: Added Entry Fields.
    class AddedEntryFields < Struct
      attribute? :personal_names, Types::Array.of(AddedEntryField::PersonalName)
      attribute? :corporate_names, Types::Array.of(AddedEntryField::CorporateName)
    end
  end
end
