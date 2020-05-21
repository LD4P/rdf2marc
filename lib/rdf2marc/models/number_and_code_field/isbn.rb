# frozen_string_literal: true

module Rdf2marc
  module Models
    module NumberAndCodeField
      # Model for 020 - International Standard Book Number.
      class Isbn < Struct
        attribute? :isbn, Types::String
        attribute? :availability_terms, Types::String
        attribute? :qualifying_infos, Types::Array.of(Types::String)
        attribute? :cancelled_isbns, Types::Array.of(Types::String)
      end
    end
  end
end
