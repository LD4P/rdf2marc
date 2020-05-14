module Rdf2marc
  module Models
    class ControlFields < Struct
      attribute? :control_number, Types::String
      attribute? :control_number_id, Types::String
      attribute? :latest_transaction, Types::DateTime
      attribute :general_info, ControlField::GeneralInfo
    end
  end
end