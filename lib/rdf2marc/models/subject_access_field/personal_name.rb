# frozen_string_literal: true

module Rdf2marc
  module Models
    module SubjectAccessField
      class PersonalName < Struct
        attribute :type, Types::String.default('surname').enum('forename', 'surname', 'family_name')
        attribute? :personal_name, Types::String
        attribute? :numeration, Types::String
        attribute? :title_and_words, Types::Array.of(Types::String)
        attribute? :dates, Types::String
        attribute? :relator_terms, Types::Array.of(Types::String)
        attribute? :work_date, Types::String
        attribute? :misc_infos, Types::Array.of(Types::String)
        attribute? :medium, Types::String
        attribute? :attribution_qualifiers, Types::Array.of(Types::String)
        attribute? :form_subheadings, Types::Array.of(Types::String)
        attribute? :work_language, Types::String
        attribute? :music_performance_mediums, Types::Array.of(Types::String)
        attribute? :part_numbers, Types::Array.of(Types::String)
        attribute? :music_arranged_statement, Types::String
        attribute? :part_names, Types::Array.of(Types::String)
        attribute? :fuller_form, Types::String
        attribute? :music_key, Types::String
        attribute? :versions, Types::Array.of(Types::String)
        attribute? :work_title, Types::String
        attribute? :affiliation, Types::String
        attribute? :form_subdivisions, Types::Array.of(Types::String)
        attribute? :general_subdivisions, Types::Array.of(Types::String)
        attribute? :chronological_subdivisions, Types::Array.of(Types::String)
        attribute? :geographic_subdivisions, Types::Array.of(Types::String)
        attribute? :authority_record_control_numbers, Types::Array.of(Types::String)
        attribute? :uri, Types::Array.of(Types::String)
        attribute? :heading_source, Types::String
        attribute? :materials_specified, Types::String
        attribute? :relationships, Types::Array.of(Types::String)
        attribute? :linkage, Types::String
        attribute? :field_links, Types::Array.of(Types::String)
      end
    end
  end
end
