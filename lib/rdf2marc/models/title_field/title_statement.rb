# frozen_string_literal: true

module Rdf2marc
  module Models
    module TitleField
      # Model for 245 - Title Statement.
      class TitleStatement < Struct
        attribute :added_entry, Types::String.default('added').enum('added', 'no_added')
        attribute :nonfile_characters, Types::Integer.default(0)
        attribute? :title, Types::String
        attribute? :remainder_of_title, Types::String
        attribute? :statement_of_responsibility, Types::String
        attribute? :medium, Types::String
        attribute? :part_numbers, Types::Array.of(Types::String)
        attribute? :part_names, Types::Array.of(Types::String)
      end
    end
  end
end
