# frozen_string_literal: true

module Rdf2marc
  module Models
    module EditionImprintField
      # Model for 264 - Production, Publication, Distribution, Manufacture, and Copyright Notice
      class PublicationDistribution < Struct
        attribute :entity_function, Types::String.default('publication').enum('production',
                                                                              'publication',
                                                                              'distribution',
                                                                              'manufacture',
                                                                              'copyright_notice_date')
        attribute? :publication_distribution_places, Types::Array.of(Types::String)
        attribute? :publisher_distributor_names, Types::Array.of(Types::String)
        attribute? :publication_distribution_dates, Types::Array.of(Types::String)
      end
    end
  end
end
