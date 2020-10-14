# frozen_string_literal: true

module Rdf2marc
  module Models
    module HoldingsEtcField
      # Model for 856 - Electronic Location and Access.
      class ElectronicLocation < Struct
        attribute :access_method, Types::String.default('http').enum('email', 'ftp', 'telnet', 'dial-up', 'http')
        attribute? :uris, Types::Array.of(Types::String)
      end
    end
  end
end
