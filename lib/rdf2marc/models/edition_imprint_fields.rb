# frozen_string_literal: true

module Rdf2marc
  module Models
    class EditionImprintFields < Struct
      attribute? :editions, Types::Array.of(EditionImprintField::Edition)
    end
  end
end