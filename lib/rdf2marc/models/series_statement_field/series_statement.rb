# frozen_string_literal: true

module Rdf2marc
  module Models
    module SeriesStatementField
      # Model for 490 - Series Statement.
      class SeriesStatement < Struct
        attribute :tracing_policy, Types::String.default('not_traced').enum('not_traced', 'traced')
        attribute? :series_statements, Types::Array.of(Types::String)
      end
    end
  end
end
