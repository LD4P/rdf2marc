# frozen_string_literal: true

require 'rdf2marc/model2marc/fields_shared_examples'

RSpec.describe Rdf2marc::Model2marc::Field040 do
  let(:model) do
    {
      number_and_code_fields: {
        cataloging_source: {
          cataloging_agency: 'cataloging_agency1',
          cataloging_language: 'language1',
          transcribing_agency: 'transcribing_agency1',
          modifying_agencies: %w[modifying_agency1 modifying_agency2],
          description_conventions: %w[convention1 convention2]
        }
      }
    }
  end

  let(:expected_fields) { ['040    $a cataloging_agency1 $b language1 $c transcribing_agency1 $d modifying_agency1 $d modifying_agency2 $e convention1 $e convention2'] }

  include_examples 'fields', '040'
end
