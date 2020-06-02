# frozen_string_literal: true

module Rdf2marc
  module Models
    module SeriesStatementField
      # Model for 490 - Series Statement.
      class SeriesStatement < Struct
        attribute? :series_statements, Types::Array.of(Types::String)
      end
    end
  end
end
