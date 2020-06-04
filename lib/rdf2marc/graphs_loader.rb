# frozen_string_literal: true

module Rdf2marc
  # Helper for loading graphs.
  class GraphsLoader
    def self.from_instance_uri(uri)
      instance_graph = from_uri(uri)
      work_uri = Rdf2marc::GraphHelper.new(instance_graph).instance_of_uri
      raise BadRequestError, 'Work (bf:instanceOf) not specified for Instance' unless work_uri

      work_graph = from_uri(work_uri)

      admin_metadata_uri = Rdf2marc::GraphHelper.new(instance_graph).admin_metadata_uri
      raise BadRequestError, 'Work (bf:adminMetadata) not specified for Instance' unless admin_metadata_uri

      admin_metadata_graph = from_uri(admin_metadata_uri)

      [instance_graph, work_graph, admin_metadata_graph]
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
