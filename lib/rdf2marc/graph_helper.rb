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

    def work_term
      @work_term ||= query.path_first([BF.instanceOf], subject_term: resource_term)
    end

    def admin_metadata_term
      @admin_metadata_term ||= query.path_first([BF.adminMetadata], subject_term: resource_term)
    end

    private

    attr_reader :graph, :sparql, :query

    def resource_term
      @resource_term ||= RDF::URI.new(uri)
    end
  end
end
