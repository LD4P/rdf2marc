# frozen_string_literal: true

module Rdf2marc
  module Models
    class GeneralInfo < Struct
      attribute? :date_entered, Types::Date
      attribute? :date1, Types::String
      attribute? :language, Types::String
    end
  end
end
