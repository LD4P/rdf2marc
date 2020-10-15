# frozen_string_literal: true

require 'rdf2marc/model2marc/fields_shared_examples'

RSpec.describe Rdf2marc::Model2marc::Field010 do
  let(:model) do
    {
      number_and_code_fields: {
        lccn: {
          lccn: 'lccn1',
          cancelled_lccns: %w[cancelled_lccn1 cancelled_lccn2]
        }
      }
    }
  end

  let(:expected_fields) { ['010    $a lccn1 $z cancelled_lccn1 $z cancelled_lccn2'] }

  include_examples 'fields', '010'
end
