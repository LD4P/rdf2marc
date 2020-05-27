# frozen_string_literal: true

module Rdf2marc
  module Models
    module NumberAndCodeField
      # Model for 050 - Library of Congress Call Number.
      class LcCallNumber < Struct
        attribute :assigned_by, Types::String.default('lc').enum('lc', 'other')
        attribute? :classification_numbers, Types::Array.of(Types::String)
        attribute? :item_number, Types::String
      end
    end
  end
end
