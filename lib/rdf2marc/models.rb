module Rdf2marc
  module Models
    # DRY Types
    module Types
      include Dry.Types()
    end

    # Base class for Models
    class Struct < Dry::Struct
      transform_keys(&:to_sym)

      schema schema.strict
    end
  end
end