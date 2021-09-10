# frozen_string_literal: true

module Rdf2marc
  module Resolver
    # Resolver for MARC country codes from id.loc.gov
    class CountryCode
      UNKNOWN = 'xx'

      def self.resolve_from_geographic_area_code(code)
        code ? lookup_country_from_geoarea(code) : UNKNOWN
      end

      def self.lookup_country_from_geoarea(code)
        code = code.chomp('---') # handle codes like e-gx---
        graph = RDF::Graph.load("https://id.loc.gov/vocabulary/geographicAreas/#{code}")
        result = graph.query(predicate: RDF::URI('http://www.loc.gov/mads/rdf/v1#hasExactExternalAuthority'))
        place = result.map(&:object).map(&:value).first
        return UNKNOWN unless place

        place.delete_prefix('http://id.loc.gov/vocabulary/countries/')
      end

      private_class_method :lookup_country_from_geoarea
    end
  end
end
