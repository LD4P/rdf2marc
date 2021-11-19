# frozen_string_literal: true

module Rdf2marc
  module Rdf2model
    module Mappers
      # Mapping to Added Entry Fields model.
      class LiteralOrRemoteResolver
        # @param [RDF::Literal,RDF::URI] term
        # @param [Rdf2marc::ItemContext] item
        # @param [Symbol] key_symbol one of (:personal_name, :corporate_name, :meeting_name, etc.)
        # @param [Class] model the Ruby class to resolve for the model.
        #                      (e.g. Rdf2marc::Models::General::PersonalName, etc.)
        def self.resolve(term:, key_symbol:, item:, model:)
          return nil unless term
          return { thesaurus: 'not_specified', key_symbol => term.value } if term.is_a?(RDF::Literal)

          model = Resolver.resolve_model(term.value, model)

          return model if model

          result = { thesaurus: 'not_specified', authority_record_control_numbers: [term.value] }
          label = item.work.query.path_first_literal([RDF::RDFS.label], subject_term: term)
          result[key_symbol] = label if label && label != term.to_s
          result
        end
      end
    end
  end
end
