# frozen_string_literal: true

module Rdf2marc
  # Mapping RDF to model.
  module Rdf2model
    def self.to_model(graph, instance_term, work_term, admin_metadata_term)
      item_context = item_context_for(graph, instance_term, work_term, admin_metadata_term)

      record_params = Mapper.new(item_context).generate
      Rdf2marc::Models::Record.new(record_params.deep_compact)
    end

    def self.item_context_for(graph, instance_term, work_term, admin_metadata_term)
      instance_context = graph_context_for(graph, instance_term)
      work_context = graph_context_for(graph, work_term)
      admin_metadata_context = graph_context_for(graph, admin_metadata_term)
      ItemContext.new(instance_context, work_context, admin_metadata_context)
    end

    def self.graph_context_for(graph, term)
      GraphContext.new(graph, term, GraphQuery.new(graph, default_subject_term: term))
    end
    private_class_method :graph_context_for
  end
end
