# frozen_string_literal: true

RSpec.describe Rdf2marc::Model2marc::Field884 do
  let(:model) do
    {
      holdings_etc_fields: {
        description_conversion_infos: [
          {
            conversion_process: 'process1',
            conversion_date: Date.new(2020, 10, 20),
            source_metadata_identifier: 'source_metadata_identifier1',
            conversion_agency: 'conversion_agency1',
            uri: 'uri1'
          },
          {
            conversion_process: 'process2',
            conversion_date: Date.new(2020, 10, 21),
            source_metadata_identifier: 'source_metadata_identifier2',
            uri: 'uri2'
          }
        ]
      }
    }
  end

  let(:expected_fields) do
    [
      '884    $a process1 $g 20201020 $k source_metadata_identifier1 $q conversion_agency1 $u uri1',
      '884    $a process2 $g 20201021 $k source_metadata_identifier2 $u uri2'
    ]
  end

  include_examples 'fields', '884'
end
