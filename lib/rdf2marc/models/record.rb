module Rdf2marc
  module Models
    class Record < Struct
      attribute :leader, Leader
      attribute :control_fields, ControlFields
      attribute :number_and_code_fields, NumberAndCodeFields
      attribute :main_entry_fields, MainEntryFields
      attribute :title_fields, TitleFields
      attribute :physical_description_fields, PhysicalDescriptionFields
      attribute :edition_imprint_fields, EditionImprintFields
      attribute :subject_access_fields, SubjectAccessFields
      attribute :added_entry_fields, AddedEntryFields
    end
  end
end