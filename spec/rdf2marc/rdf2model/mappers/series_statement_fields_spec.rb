# frozen_string_literal: true

require 'rdf2marc/rdf2model/mappers/mappers_shared_examples'

RSpec.describe Rdf2marc::Rdf2model::Mappers::SeriesStatementFields do
  context 'with minimal graph' do
    let(:ttl) { '' }

    let(:model) do
      {}
    end

    include_examples 'mapper', described_class
  end

  describe 'series statements' do
    let(:ttl) do
      <<~TTL
        <#{instance_term}> <http://id.loc.gov/ontologies/bibframe/seriesStatement> "Bulletin / U.S. Department of Labor, Bureau of Labor Statistics"@eng, "Research report / National Education Association Research"@eng.
      TTL
    end

    let(:model) do
      {
        series_statements: [
          {
            series_statements: ['Bulletin / U.S. Department of Labor, Bureau of Labor Statistics']
          },
          {
            series_statements: ['Research report / National Education Association Research']
          }
        ]
      }
    end

    include_examples 'mapper', described_class
  end
end
