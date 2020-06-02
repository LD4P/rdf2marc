# frozen_string_literal: true

module Rdf2marc
  module Models
    module ControlField
      # Model for Heading Fields - General Information.
      class GeneralInfo < Struct
        attribute? :date_entered, Types::Date
        attribute? :date1, Types::String
        attribute? :place, Types::String
        attribute? :language, Types::String
      end
    end
  end
end
