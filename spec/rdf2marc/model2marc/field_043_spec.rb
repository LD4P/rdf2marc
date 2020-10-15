# frozen_string_literal: true

require 'rdf2marc/model2marc/fields_shared_examples'

RSpec.describe Rdf2marc::Model2marc::Field043 do
  let(:model) do
    {
      number_and_code_fields: {
        geographic_area_code: {
          geographic_area_codes: %w[gac1 gac2]
        }
      }
    }
  end

  let(:expected_fields) { ['043    $a gac1 $a gac2'] }

  include_examples 'fields', '043'
end
