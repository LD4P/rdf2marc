# frozen_string_literal: true

module Rdf2marc
  module Rdf2model
    # Maps RDF to model parameters.
    class Mapper < BaseMapper
      def generate
        {
          leader: Mappers::Leader.new(item).generate,
          control_fields: Mappers::ControlFields.new(item).generate,
          number_and_code_fields: Mappers::NumberAndCodeFields.new(item).generate,
          main_entry_fields: Mappers::MainEntryFields.new(item).generate,
          title_fields: Mappers::TitleFields.new(item).generate,
          physical_description_fields: Mappers::PhysicalDescriptionFields.new(item).generate,
          series_statement_fields: Mappers::SeriesStatementFields.new(item).generate,
          note_fields: Mappers::NoteFields.new(item).generate,
          edition_imprint_fields: Mappers::EditionImprintFields.new(item).generate,
          subject_access_fields: Mappers::SubjectAccessFields.new(item).generate,
          added_entry_fields: Mappers::AddedEntryFields.new(item).generate
        }
      end
    end
  end
end
