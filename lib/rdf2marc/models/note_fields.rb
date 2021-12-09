# frozen_string_literal: true

module Rdf2marc
  module Models
    # Model for 5XX: Note Fields.
    class NoteFields < Struct
      attribute? :general_notes, Types::Array.of(NoteField::GeneralNote)
      attribute? :table_of_contents, Types::Array.of(Types::String)
    end
  end
end
