# frozen_string_literal: true

module Rdf2marc
  module Queries
    # Finds contributors in the RDF
    class Contributions
      def initialize(graph_query)
        @graph_query = graph_query
        @path = [[BF.contribution, BF.Contribution]]
      end

      # We first look for a resource that we can resolve.
      # If they aren't found we look for a b-node with RDF::RDFV.value (for backward compatability)
      def with_type(*agent_types)
        legacy_contributions_with_type(agent_types) +
          resource_contributions_with_type(agent_types)
      end

      private

      delegate :path_all, to: :@graph_query
      attr_reader :path

      def resource_contributions_with_type(agent_types)
        agent_types.map do |agent_type|
          path_all(path + [[BF.agent, agent_type]]).reject(&:node?)
        end.flatten
      end

      def legacy_contributions_with_type(agent_types)
        agent_types.map do |agent_type|
          path_all(path + [[BF.agent, agent_type], [RDF::RDFV.value]])
        end.flatten
      end
    end
  end
end
