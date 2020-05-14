# frozen_string_literal: true

module Rdf2marc
  module Models
    class TitleFields < Struct
      attribute? :translated_titles, Types::Array.of(TitleField::TranslatedTitle)
      attribute? :title_statement, TitleField::TitleStatement
      attribute? :variant_titles, Types::Array.of(TitleField::VariantTitle)
      attribute? :former_titles, Types::Array.of(TitleField::FormerTitle)
    end
  end
end