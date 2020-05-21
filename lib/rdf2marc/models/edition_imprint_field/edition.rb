# frozen_string_literal: true

module Rdf2marc
  module Models
    module EditionImprintField
      # Model for 250 - Edition Statement.
      class Edition < Struct
        attribute? :edition, Types::String
      end
    end
  end
end
