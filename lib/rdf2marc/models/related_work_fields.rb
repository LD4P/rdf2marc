# frozen_string_literal: true

module Rdf2marc
  module Models
    # Model for 758: Resource Identifier
    # See https://www.loc.gov/marc/bibliographic/bd758.html
    class RelatedWorkFields < Struct
      attribute :title, Types::String
      attribute :uri, Types::String
    end
  end
end
