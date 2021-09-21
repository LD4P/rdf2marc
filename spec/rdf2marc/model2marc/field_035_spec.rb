# frozen_string_literal: true

RSpec.describe Rdf2marc::Model2marc::Field040 do
  let(:model) do
    {
      number_and_code_fields: {
        oclc_record_number: '1141759043'
      }
    }
  end

  let(:expected_fields) { ['035    $a (OCoLC)1141759043'] }

  include_examples 'fields', '035'
end
