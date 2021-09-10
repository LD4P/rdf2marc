# frozen_string_literal: true

require 'rdf2marc/model2marc/fields_shared_examples'

RSpec.describe Rdf2marc::Model2marc::ControlField008 do
  context 'with minimal model' do
    let(:model) do
      {
        control_fields: {
          general_info: {}
        }
      }
    end

    let(:expected_fields) { ['008 201001|||||||||xx                     ||'] }

    before do
      allow(Date).to receive(:today).and_return(Date.new(2020, 10, 1))
    end

    include_examples 'fields', '008'
  end

  context 'with model' do
    let(:model) do
      {
        control_fields: {
          general_info: {
            date_entered: Date.new(2020, 10, 15),
            date1: '202x',
            place: 'gau',
            language: 'ace'
          }
        }
      }
    end

    let(:expected_fields) { ['008 201015s202u    gau                 ace||'] }

    before do
      allow(Date).to receive(:today).and_return(Date.new(2020, 10, 1))
    end

    include_examples 'fields', '008'
  end
end
