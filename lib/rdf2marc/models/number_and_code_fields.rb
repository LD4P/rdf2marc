# frozen_string_literal: true

module Rdf2marc
  module Models
    class NumberAndCodeFields < Struct
      attribute? :lccn, NumberAndCodeField::Lccn
      attribute? :isbns, Types::Array.of(NumberAndCodeField::Isbn)
    end
  end
end