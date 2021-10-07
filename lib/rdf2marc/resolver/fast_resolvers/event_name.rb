# frozen_string_literal: true

module Rdf2marc
  module Resolver
    module FastResolvers
      # Mapper for event names.
      class EventName < BaseMapper
        def map
          {
            thesaurus: 'subfield2',
            source: 'fast',
            name: title,
            uris: [uri]
          }
        end
      end
    end
  end
end
