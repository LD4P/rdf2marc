# frozen_string_literal: true

module Rdf2marc
  module Models
    module EditionImprintField
      class Edition < Struct
        attribute? :edition, Types::String
      end
    end
  end
end