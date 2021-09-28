# frozen_string_literal: true

RSpec.describe Rdf2marc::Model2marc::Field758 do
  let(:model) do
    {
      work: {
        uri: 'https://api.stage.sinopia.io/resource/7b03cc32-d121-490e-bae6-8ba51ff8e95a',
        title: 'Physica. English'
      }
    }
  end

  let(:expected_fields) do
    ['758    $4 http://id.loc.gov/ontologies/bibframe/instanceOf $i Instance of: $a Physica. English $0 https://api.stage.sinopia.io/resource/7b03cc32-d121-490e-bae6-8ba51ff8e95a']
  end

  include_examples 'fields', '758'
end
