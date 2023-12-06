# frozen_string_literal: true

module Rdf2marc
  module Rdf2model
    module Mappers
      # Mapping to Series Statement Fields model.
      class SeriesStatementFields < BaseMapper
        def generate
          {
            series_statements:
          }
        end

        private

        def series_statements
          item.instance.query.path_all_literal([BF.seriesStatement]).sort.map do |series_statement|
            {
              series_statements: [series_statement]
            }
          end
        end
      end
    end
  end
end
