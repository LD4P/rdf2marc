# frozen_string_literal: true

module Rdf2marc
  module Models
    module NumberAndCodeField
      # Model for 010 - Library of Congress Control Number.
      class Lccn < Struct
        attribute? :lccn, Types::String
        attribute? :cancelled_lccns, Types::Array.of(Types::String)
      end
    end
  end
end
