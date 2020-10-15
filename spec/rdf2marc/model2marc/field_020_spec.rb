# frozen_string_literal: true

require 'rdf2marc/model2marc/fields_shared_examples'

RSpec.describe Rdf2marc::Model2marc::Field020 do
  let(:model) do
    {
      number_and_code_fields: {
        isbns: [
          {
            isbn: 'isbn1',
            qualifying_infos: %w[qualifying_info1 qualifying_info2],
            cancelled_isbns: %w[cancelled_isbn1 cancelled_isbn2]
          },
          {
            isbn: 'isbn2'
          }
        ]
      }
    }
  end

  let(:expected_fields) do
    [
      '020    $a isbn1 $q qualifying_info1 $q qualifying_info2 $z cancelled_isbn1 $z cancelled_isbn2',
      '020    $a isbn2'
    ]
  end

  include_examples 'fields', '020'
end
