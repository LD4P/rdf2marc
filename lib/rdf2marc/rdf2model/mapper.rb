# frozen_string_literal: true

module Rdf2marc
  module Rdf2model
    # Maps RDF to model parameters.
    class Mapper < BaseMapper
      def generate
        main_entry = Mappers::MainEntryFields.new(item).generate
        has_100_field = main_entry.compact.keys.present?
        {
          leader: Mappers::Leader.new(item).generate,
          control_fields: Mappers::ControlFields.new(item).generate,
          number_and_code_fields: Mappers::NumberAndCodeFields.new(item).generate,
          main_entry_fields: main_entry,
          title_fields: Mappers::TitleFields.new(item, has_100_field: has_100_field).generate,
          physical_description_fields: Mappers::PhysicalDescriptionFields.new(item).generate,
          series_statement_fields: Mappers::SeriesStatementFields.new(item).generate,
          note_fields: Mappers::NoteFields.new(item).generate,
          edition_imprint_fields: Mappers::EditionImprintFields.new(item).generate,
          subject_access_fields: Mappers::SubjectAccessFields.new(item).generate,
          added_entry_fields: Mappers::AddedEntryFields.new(item).generate,
          holdings_etc_fields: Mappers::HoldingsEtcFields.new(item).generate
        }
      end
    end
  end
end
