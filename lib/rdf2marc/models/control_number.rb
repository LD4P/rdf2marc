# frozen_string_literal: true

module Rdf2marc
  module Models
    class ControlNumber < Struct
      attribute? :control_number, Types::String
    end
  end
end