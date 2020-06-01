# frozen_string_literal: true

module Rdf2marc
  module Models
    module EditionImprintField
      # Model for 260 - Publication, Distribution, etc. (Imprint).
      class PublicationDistribution < Struct
        attribute? :publication_distribution_places, Types::Array.of(Types::String)
        attribute? :publisher_distributor_names, Types::Array.of(Types::String)
        attribute? :publication_distribution_dates, Types::Array.of(Types::String)
        attribute? :manufacture_places, Types::Array.of(Types::String)
        attribute? :manufacturer_names, Types::Array.of(Types::String)
        attribute? :manufacture_dates, Types::Array.of(Types::String)
      end
    end
  end
end
