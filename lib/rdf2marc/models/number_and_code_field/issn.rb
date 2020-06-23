# frozen_string_literal: true

module Rdf2marc
  module Models
    module NumberAndCodeField
      # Model for 022 - International Standard Serial Number.
      class Isbn < Struct
        attribute? :issn, Types::String
        attribute? :issnl, Types::String
        attribute? :cancelled_issnls, Types::Array.of(Types::String)
        attribute? :incorrect_issns, Types::Array.of(Types::String)
        attribute? :cancelled_issns, Types::Array.of(Types::String)
      end
    end
  end
end
