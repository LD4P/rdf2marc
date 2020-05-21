# frozen_string_literal: true

module Rdf2marc
  module Models
    module TitleField
      # Model for 247 - Former Title.
      class FormerTitle < Struct
        attribute :added_entry, Types::String.default('added').enum('added', 'no_added')
        attribute :note_controller, Types::String.default('no_display').enum('display', 'no_display')
        attribute? :title, Types::String
        attribute? :remainder_of_title, Types::String
        attribute? :part_names, Types::Array.of(Types::String)
        attribute? :part_numbers, Types::Array.of(Types::String)
      end
    end
  end
end
