# frozen_string_literal: true

module Rdf2marc
  module Models
    module TitleField
      # Model for 246 - Varying Form of Title.
      class VariantTitle < Struct
        TYPES = %w[none portion parallel distinctive other cover added_title_page caption running spine].freeze
        attribute :note_added_entry, Types::String.default('note_no_added').enum('note_no_added',
                                                                                 'note_added',
                                                                                 'no_note_no_added',
                                                                                 'no_note_added')
        attribute :type, Types::String.default('none').enum(*TYPES)
        attribute? :title, Types::String
        attribute? :remainder_of_title, Types::String
        attribute? :part_names, Types::Array.of(Types::String)
        attribute? :part_numbers, Types::Array.of(Types::String)
      end
    end
  end
end
