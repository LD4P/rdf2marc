# frozen_string_literal: true

module Rdf2marc
  module Resolver
    module IdLocGovResolvers
      # Mapper for genre forms.
      class GenreForm < BaseMapper
        def map
          field = marc_record['155']
          {
            thesaurus: 'lcsh',
            genre_form_data: subfield_value(field, 'a'),
            form_subdivisions: subfield_values(field, 'v'),
            general_subdivisions: subfield_values(field, 'x'),
            chronological_subdivisions: subfield_values(field, 'y'),
            geographic_subdivisions: subfield_values(field, 'z'),
            authority_record_control_numbers: [uri],
            term_source: 'lcgft',
            linkage: subfield_value(field, '6'),
            field_links: subfield_values(field, '8')
          }
        end
      end
    end
  end
end
