# frozen_string_literal: true

module Rdf2marc
  module Models
    # Model for 4XX - Series Statement Fields.
    class SeriesStatementFields < Struct
      attribute? :series_statements, Types::Array.of(SeriesStatementField::SeriesStatement)
    end
  end
end
