# frozen_string_literal: true

module Rdf2marc
  module Queries
    # Finds primary contributors in the RDF
    class PrimaryContributions
      def initialize(graph_query)
        @graph_query = graph_query
        @path = [[BF.contribution, BFLC.PrimaryContribution]]
      end

      # First we look for a b-node with RDF::RDFV.value (for backward compatability)
      # otherwise we look for a resource that we can resolve.
      def first_with_type(*agent_types)
        first_legacy_contribution_with_type(agent_types) ||
          first_resource_contribution_with_type(agent_types)
      end

      private

      attr_reader :path

      delegate :path_all, to: :@graph_query

      def first_resource_contribution_with_type(agent_types)
        agent_types.find do |agent_type|
          result = path_all(path + [[BF.agent, agent_type]]).reject(&:node?)
          return result.first if result.present?
        end
      end

      def first_legacy_contribution_with_type(agent_types)
        agent_types.find do |agent_type|
          result = path_all(path + [[BF.agent, agent_type], [RDF::RDFV.value]]).sort
          return result.first if result.present?
        end
      end
    end
  end
end
