# frozen_string_literal: true

module Rdf2marc
  # Helper for loading graphs.
  class GraphsLoader
    def self.from_instance_uri(uri)
      graph = from_uri(uri)

      graph_helper = Rdf2marc::GraphHelper.new(graph)
      work_term = graph_helper.work_term
      raise BadRequestError, 'Work (bf:instanceOf) not specified for Instance' unless work_term

      graph << from_uri(work_term.value) if work_term.instance_of?(RDF::URI)

      admin_metadata_term = graph_helper.admin_metadata_term
      raise BadRequestError, 'AdminMetadata (bf:adminMetadata) not specified for Instance' unless admin_metadata_term

      graph << from_uri(admin_metadata_term.value) if admin_metadata_term.instance_of?(RDF::URI)

      [graph, RDF::URI.new(uri), work_term, admin_metadata_term]
    end

    def self.from_filepaths(other_filepaths)
      instance_filepath = other_filepaths.shift
      graph = from_path(instance_filepath)

      graph_helper = Rdf2marc::GraphHelper.new(graph)
      instance_term = RDF::URI.new(graph_helper.uri)
      work_term = graph_helper.work_term
      raise BadRequestError, 'Work (bf:instanceOf) not specified for Instance' unless work_term

      admin_metadata_term = graph_helper.admin_metadata_term
      raise BadRequestError, 'AdminMetadata (bf:adminMetadata) not specified for Instance' unless admin_metadata_term

      other_filepaths.each do |filepath|
        graph << from_path(filepath)
      end

      [graph, instance_term, work_term, admin_metadata_term]
    end

    def self.from_uri(uri)
      RDF::Repository.load(uri)
    rescue StandardError
      raise BadRequestError, "Unable to load #{uri}"
    end

    def self.from_path(filepath)
      RDF::Repository.load(filepath)
    rescue StandardError
      raise BadRequestError, "Unable to load #{filepath}"
    end
  end
end
