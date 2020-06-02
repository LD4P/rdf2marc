# frozen_string_literal: true

module Rdf2marc
  module Models
    module NoteField
      # Model for 500 - General Note.
      class GeneralNote < Struct
        attribute? :general_note, Types::String
      end
    end
  end
end
