# frozen_string_literal: true

module Rdf2marc
  module Models
    class MainEntryFields < Struct
      attribute? :personal_name, MainEntryField::PersonalName
    end
  end
end