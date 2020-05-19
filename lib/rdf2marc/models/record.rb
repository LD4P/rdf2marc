module Rdf2marc
  module Models
    class Record < Struct
      attribute :leader, Leader
      attribute :control_fields, ControlFields
      attribute :number_and_code_fields, NumberAndCodeFields
      attribute :main_entry_fields, MainEntryFields
      attribute :title_fields, TitleFields
      attribute :subject_access_fields, SubjectAccessFields
    end
  end
end