# frozen_string_literal: true

module Rdf2marc
  module Queries
    # Finds (non-primary) contributors in the RDF
    class Contributions
      def initialize(graph_query)
        @graph_query = graph_query
        @path = [[BF.contribution, BF.Contribution]]
      end

      # We need the contributors of the correct type and the roles associated with each such contributor
      # @return [Array] an Array with members [contributor, roles], where roles is an array
      #   because a single contributor can have multiple roles.
      #   thus: [[contributor, roles], [contributor, roles], [contributor, roles]]
      def contributors_of_type_with_roles(*agent_types)
        result = []
        # contributor_nodes are blank nodes containing contributor information
        contributor_nodes = path_all([[BF.contribution, BF.Contribution]])
        contributor_nodes.each do |contrib_node|
          contributors_of_type(contrib_node, agent_types).each do |contributor|
            result << [contributor, roles_for_contributor(contrib_node)] if contributor
          end
        end
        result
      end

      private

      delegate :path_all, :path_first, to: :@graph_query
      attr_reader :path

      # We first look for a resource that we can resolve.
      # If not found we look for a b-node with RDF::RDFV.value (for backward compatability)
      def contributors_of_type(contrib_node, agent_types)
        resource_contributors_of_type(contrib_node, agent_types) ||
          legacy_contributors_of_type(contrib_node, agent_types)
      end

      def roles_for_contributor(contrib_node)
        path_all([[BF.role]], subject_term: contrib_node)
      end

      # @return [Array] the "resource" format contributor objects that correspond to the desired agent_types
      # @example:
      # _:b1 a <http://id.loc.gov/ontologies/bflc/Contribution>;
      #     <http://id.loc.gov/ontologies/bibframe/agent> <http://id.loc.gov/authorities/names/no2005086644>;
      # <http://id.loc.gov/authorities/names/no2005086644> a <http://id.loc.gov/ontologies/bibframe/Person>;
      #     <http://www.w3.org/2000/01/rdf-schema#label> "Jung, Carl".
      def resource_contributors_of_type(contributor_node, agent_types)
        contributor_terms = path_all([[BF.agent]], subject_term: contributor_node).reject(&:node?)
        return if contributor_terms.blank?

        contributor_terms.map do |contrib_term|
          contributor_type = path_first([[RDF.type]], subject_term: contrib_term)
          agent_types.flatten.include?(contributor_type) ? contrib_term : nil
        end.compact
      end

      # @return [Array] the "legacy" format contributor objects that correspond to the desired agent_types
      # @example
      #   _:b1 a <http://id.loc.gov/ontologies/bibframe/Contribution>;
      #       <http://id.loc.gov/ontologies/bibframe/agent> _:b2.
      #   _:b2 a <http://id.loc.gov/ontologies/bibframe/Person>;
      #       <http://www.w3.org/1999/02/22-rdf-syntax-ns#value> <http://id.loc.gov/authorities/names/no2005086644>.
      def legacy_contributors_of_type(contributor_node, agent_types)
        contributor_terms = path_all([[BF.agent], [RDF::RDFV.value]], subject_term: contributor_node)
        return if contributor_terms.blank?

        # contrib_term_nodes are generally blank nodes containing the agent type and the URI of the contributor
        contrib_term_nodes = path_all([[BF.agent]], subject_term: contributor_node)
        contrib_term_nodes.map do |term_node|
          contributor_type = path_first([[RDF.type]], subject_term: term_node)
          contributor_terms = path_all([[RDF::RDFV.value]], subject_term: term_node)
          agent_types.flatten.include?(contributor_type) ? contributor_terms : nil
        end.compact
      end
    end
  end
end
