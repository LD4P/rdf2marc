module Rdf2marc
  module Models
    class Record < Struct
      attribute :leader, Leader
      attribute :control_fields, ControlFields
      attribute :number_and_code_fields, NumberAndCodeFields
      attribute :title_fields, TitleFields
    end
  end
end