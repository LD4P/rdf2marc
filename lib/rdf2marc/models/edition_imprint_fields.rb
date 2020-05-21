# frozen_string_literal: true

module Rdf2marc
  module Models
    # Model for 25X-28X: Edition, Imprint, Etc. Fields.
    class EditionImprintFields < Struct
      attribute? :editions, Types::Array.of(EditionImprintField::Edition)
    end
  end
end
