# frozen_string_literal: true

module Rdf2marc
  module Queries
    # Finds primary contributors in the RDF
    class PrimaryContributions
      def initialize(graph_query)
        @graph_query = graph_query
      end

      # First look for a b-node with RDF::RDFV.value (for backward compatability)
      # otherwise look for a resource that we can resolve.
      # otherwise look for a literal
      def first_with_type(*agent_types)
        first_legacy_contribution_with_type(agent_types) ||
          first_resource_contribution_with_type(agent_types) ||
          first_literal_contribution_with_type(agent_types)
      end

      private

      attr_reader :graph_query

      def first_resource_contribution_with_type(agent_types)
        agent_types.find do |agent_type|
          result = path_all([[BF.agent, agent_type]]).reject(&:node?)
          return result.first if result.present?
        end
      end

      def first_legacy_contribution_with_type(agent_types)
        agent_types.find do |agent_type|
          result = path_all([[BF.agent, agent_type], [RDF::RDFV.value]]).sort
          return result.first if result.present?
        end
      end

      def first_literal_contribution_with_type(agent_types)
        agent_types.find do |agent_type|
          result = path_all([[BF.agent, agent_type], [RDF::RDFS.label]]).sort
          return result.first if result.present?
        end
      end

      def path_all(path)
        graph_query.path_all([[BF.contribution, BF.PrimaryContribution]] + path) +
          # Support deprecated BFLC PrimaryContribution
          graph_query.path_all([[BF.contribution, BFLC.PrimaryContribution]] + path)
      end
    end
  end
end
