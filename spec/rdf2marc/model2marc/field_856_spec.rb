# frozen_string_literal: true

require 'rdf2marc/model2marc/fields_shared_examples'

RSpec.describe Rdf2marc::Model2marc::Field856 do
  let(:model) do
    {
      holdings_etc_fields: {
        electronic_locations: [
          {
            access_method: 'email',
            uris: %w[uri1 uri2]
          },
          {
            uris: ['uri3']
          }
        ]
      }
    }
  end

  let(:expected_fields) do
    [
      '856 0  $u uri1 $u uri2',
      '856 4  $u uri3'
    ]
  end

  include_examples 'fields', '856'
end
