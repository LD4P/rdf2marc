module Rdf2marc
  module Models
    class Record < Struct
      attribute? :title_statement, TitleStatement
    end
  end
end