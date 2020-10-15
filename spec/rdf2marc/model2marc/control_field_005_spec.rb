# frozen_string_literal: true

require 'rdf2marc/model2marc/fields_shared_examples'

RSpec.describe Rdf2marc::Model2marc::ControlField005 do
  let(:model) do
    {
      control_fields: {
        latest_transaction: DateTime.new(2001, 2, 3, 4, 5, 6),
        general_info: []
      }
    }
  end

  let(:expected_fields) { ['005 20010203040506.0'] }

  include_examples 'fields', '005'
end
