# frozen_string_literal: true

module Rdf2marc
  module Models
    # Model for a bibliographic record.
    class Record < Struct
      attribute :leader, Leader
      attribute :control_fields, ControlFields
      attribute :number_and_code_fields, NumberAndCodeFields
      attribute :main_entry_fields, MainEntryFields
      attribute :title_fields, TitleFields
      attribute :physical_description_fields, PhysicalDescriptionFields
      attribute :series_statement_fields, SeriesStatementFields
      attribute :edition_imprint_fields, EditionImprintFields
      attribute :note_fields, NoteFields
      attribute :subject_access_fields, SubjectAccessFields
      attribute :added_entry_fields, AddedEntryFields
      attribute :holdings_etc_fields, HoldingsEtcFields
      attribute :work, RelatedWorkFields
    end
  end
end
