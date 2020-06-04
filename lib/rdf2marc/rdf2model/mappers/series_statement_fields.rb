module Rdf2marc
  module Rdf2model
    module Mappers
      class SeriesStatementFields < BaseMapper
        def generate
          {
              series_statements: series_statements
          }
        end

        private

        def series_statements
          item.instance.query.path_all_literal([BF.seriesStatement]).map do |series_statement|
            {
                series_statements: [series_statement]
            }
          end
        end

      end
    end
  end
end