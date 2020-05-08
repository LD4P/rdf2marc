module Rdf2marc
  module Models
    class TitleStatement < Struct
      attribute :added_entry, Types::Bool.default(true)
      attribute :nonfile_characters, Types::Integer.default(0)
      attribute? :title, Types::String
      attribute? :remainder_of_title, Types::String
      attribute? :statement_of_responsibility, Types::String
      attribute? :medium, Types::String
    end
  end
end