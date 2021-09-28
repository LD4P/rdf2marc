# frozen_string_literal: true

RSpec.describe Rdf2marc::Model2marc::Field758 do
  let(:model) do
    {
      holdings_etc_fields: {
        description_conversion_infos: [
          {
            conversion_process: 'Sinopia rdf2marc',
            conversion_date: Date.today,
            source_metadata_identifier: 'https://api.stage.sinopia.io/resource/3eb5f480-60d6-4732-8daf-02d8d6f26eb7',
            uri: 'https://github.com/LD4P/rdf2marc'
          }
        ]
      },
      title_fields: {
        title_statement: {
          title: 'Physica'
        }
      }
    }
  end

  let(:expected_fields) do
    ['758    $4 http://id.loc.gov/ontologies/bibframe/instanceOf $e Instance of: $a Physica $1 https://api.stage.sinopia.io/resource/3eb5f480-60d6-4732-8daf-02d8d6f26eb7']
  end

  include_examples 'fields', '758'
end
