# frozen_string_literal: true

module Rdf2marc
  module Resolver
    module MarcMappers
      # Base class for MARC Mappers.
      class BaseMapper
        def initialize(uri, marc_record)
          @marc_record = marc_record
          @uri = uri
        end

        protected

        attr_reader :marc_record, :uri

        def clean_value(value)
          return nil if value.nil?

          value.gsub(/[[,)]]$/, '').gsub(/^[(]/, '').gsub(/[ :]$/, '').strip
        end

        def subfield_values(field, code, clean: false)
          field.find_all { |subfield| subfield.code == code }.map do |subfield|
            clean ? clean_value(subfield.value) : subfield.value
          end
        end

        def subfield_value(field, code, clean: false)
          clean ? clean_value(field[code]) : field[code]
        end
      end
    end
  end
end
