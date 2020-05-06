module Rdf2marc
  module Models
    class TitleStatement < Struct
      attribute? :title, Types::String
      attribute? :remainder_of_title, Types::String
      attribute? :statement_of_responsibility, Types::String
    end
  end
end