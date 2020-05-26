# frozen_string_literal: true

module Rdf2marc
  # Helper for graphs.
  class GraphHelper
    def initialize(graph)
      @graph = graph
      @sparql = Sparql.new(graph)
      @query = GraphQuery.new(graph)
    end

    def resource_template
      @resource_template ||= sparql.path_first(['sinopia:hasResourceTemplate'])
    end

    def uri
      query = <<~SPARQL
        SELECT ?solut
        WHERE
        { 
          ?solut sinopia:hasResourceTemplate ?x .
        }
      SPARQL
      @uri ||= sparql.query_first(query)
    end

    def instance_of_uri
      @instance_of_uri ||= begin
        work_term = query.path_first([BF.instanceOf], subject_term: resource_term)
        return nil if work_term.nil?

        work_term.value
      end
    end

    def admin_metadata_uri
      @admin_metadata_uri ||= begin
        admin_metadata_term = query.path_first([BF.adminMetadata], subject_term: resource_term)
        return nil if admin_metadata_term.nil?

        admin_metadata_term.value
      end
    end

    private

    attr_reader :graph, :sparql, :query

    def resource_term
      @resource_term ||= RDF::URI.new(uri)
    end
  end
end
