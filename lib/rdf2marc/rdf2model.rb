# frozen_string_literal: true

module Rdf2marc
  # Mapping RDF to model.
  module Rdf2model
    def self.to_model(instance_graph, work_graph, admin_metadata_graph)
      instance_context = graph_context_for(instance_graph)
      work_context = graph_context_for(work_graph)
      admin_metadata_context = graph_context_for(admin_metadata_graph)
      item_context = ItemContext.new(instance_context, work_context, admin_metadata_context)

      record_params = Mapper.new(item_context).generate
      Rdf2marc::Models::Record.new(record_params.deep_compact)
    end

    def self.graph_context_for(graph)
      uri = GraphHelper.new(graph).uri
      term = RDF::URI.new(uri)
      GraphContext.new(graph, uri, term, GraphQuery.new(graph, default_subject_term: term) )
    end
    private_class_method :graph_context_for

  end
end
