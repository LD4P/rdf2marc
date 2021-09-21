# frozen_string_literal: true

module Rdf2marc
  module Models
    module General
      # General model for Meeting Name.
      class MeetingName < Struct
        attribute? :type, Types::String.enum('inverted', 'jurisdiction', 'direct')
        attribute :thesaurus, Types::String.default('not_specified').enum('lcsh',
                                                                          'lcsh_childrens_literature',
                                                                          'mesh',
                                                                          'nal_subject_authority',
                                                                          'not_specified',
                                                                          'canadian_subject_headings',
                                                                          'répertoire_de_vedettes-matière',
                                                                          'subfield2')
        attribute? :meeting_name, Types::String
        # in marc subfield order:
        attribute? :meeting_locations, Types::Array.of(Types::String)
        attribute? :meeting_dates, Types::Array.of(Types::String)
        attribute? :subordinate_units, Types::Array.of(Types::String)
        attribute? :work_date, Types::String
        attribute? :misc_infos, Types::Array.of(Types::String)
        attribute? :medium, Types::String
        attribute? :relationship_info, Types::Array.of(Types::String)
        attribute? :relator_terms, Types::Array.of(Types::String)
        attribute? :attribution_qualifiers, Types::Array.of(Types::String)
        attribute? :form_subheadings, Types::Array.of(Types::String)
        attribute? :work_language, Types::String
        attribute? :part_numbers, Types::Array.of(Types::String)
        attribute? :part_names, Types::Array.of(Types::String)
        attribute? :following_meeting_name, Types::String
        attribute? :versions, Types::Array.of(Types::String)
        attribute? :work_title, Types::String
        attribute? :affiliation, Types::String
        attribute? :form_subdivisions, Types::Array.of(Types::String)
        attribute? :general_subdivisions, Types::Array.of(Types::String)
        attribute? :chronological_subdivisions, Types::Array.of(Types::String)
        attribute? :geographic_subdivisions, Types::Array.of(Types::String)
        attribute? :issn, Types::String
        attribute? :authority_record_control_numbers, Types::Array.of(Types::String)
        attribute? :uris, Types::Array.of(Types::String)
        attribute? :heading_source, Types::String
        attribute? :materials_specified, Types::String
        attribute? :relationships, Types::Array.of(Types::String)
        attribute? :institution_applies_to, Types::String
        attribute? :linkage, Types::String
        attribute? :field_links, Types::Array.of(Types::String)
      end
    end
  end
end
