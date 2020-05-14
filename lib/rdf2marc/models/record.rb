module Rdf2marc
  module Models
    class Record < Struct
      attribute :leader, Leader
      attribute :control_fields, ControlFields
      attribute :title_fields, TitleFields
    end
  end
end