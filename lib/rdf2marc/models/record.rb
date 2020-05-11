module Rdf2marc
  module Models
    class Record < Struct
      attribute :leader, Leader
      attribute? :translated_titles, Types::Array.of(TranslatedTitle)
      attribute? :title_statement, TitleStatement
      attribute? :variant_titles, Types::Array.of(VariantTitle)
      attribute? :former_titles, Types::Array.of(FormerTitle)
    end
  end
end